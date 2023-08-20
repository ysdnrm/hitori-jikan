class Post < ApplicationRecord
  # 複数画像投稿
  has_many_attached :images
  # アソシエーション
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # いいね機能でのユーザーの存在
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
# enum
  # 曜日選択         {日曜: 0、月曜: 1、火曜: 2、水曜: 3、木曜: 4、金曜: 5、土曜: 6、祝日: 7}
  enum stay_weekday: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, holiday: 7 }
  # 混み具合選択          {空いている: 0、半分くらい: 1、ほぼ満席: 2、待っている人も居た: 3}
  enum congestion_degree: { empty: 0, half: 1, full: 2, over: 3 }
  # 下書き機能.     {投稿する: 0、下書きする: 1 }
  enum save_status: { published: 0, draft: 1 }

  # 投稿画像について
  def get_image#(height, width)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    images#.variant(resize_to_limit: [height, width]).processed
  end

  # タグのリレーションのみ記載
  has_many :post_shop_tags, dependent: :destroy
  has_many :shop_tags, through: :post_shop_tags

  def save_shop_tags(tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.shop_tags.pluck(:name) unless self.shop_tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = tags - current_tags
    # 古いタグを消す
    old_tags.each do |old_name|
      self.shop_tags.delete ShopTag.find_by(name:old_name)
    end
    # 新しいタグを保存
    new_tags.each do |new_name|
      shop_tag = ShopTag.find_or_create_by(name:new_name)
      self.shop_tags << shop_tag
    end
  end

  # キーワード、タグ検索
  scope :search_by_keywords, ->(keywords) {
    keywords_array = keywords.split(/\s+/) # キーワードをスペースで分割して配列化

    self.joins(:post_shop_tags).joins(:shop_tags).where( 
      keywords_array.map do |_|
        [
          'shop_name LIKE :keyword',
          'shop_introduction LIKE :keyword',
          'shop_postal_code LIKE :keyword',
          'shop_address LIKE :keyword',
          'stay_weekday LIKE :keyword', # enum の場合、値の一致を確認
          'stay_time_start LIKE :keyword',
          'stay_time_end LIKE :keyword',
          'congestion_degree LIKE :keyword', # enum の場合、値の一致を確認
          'shop_tags.name LIKE :keyword' #shop_tagsテーブルのnameカラム
        ].join(' OR ')
      end.join(' OR '),
      *keywords_array.map { |keyword| { keyword: "%#{keyword}%" } }
    ).uniq  #投稿が重複しないように
  }


  # バリデーション
  with_options presence: true do
    validates :shop_name
    validates :shop_introduction
    validates :shop_postal_code
    validates :shop_address
    validates :stay_weekday
    validates :stay_time_start
    validates :stay_time_end
    validates :congestion_degree
  end

end