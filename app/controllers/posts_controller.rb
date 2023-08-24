class PostsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    @post.user_id = current_user.id
     # 受け取った値を,で区切って配列にする
    @shop_tags = params[:post][:name].split(',')
    # @post.save_status = params[:post][:save_status]

    if @post.save
      @post.save_shop_tags(shop_tags)
      redirect_to post_path(@post)
    else
      render "new"
    end

  end

  # 下書き
  def confirm
    @posts = current_user.posts.draft.all
    # find_by(params[:post_id])
  end

  def index
    @posts = Post.published.all # 公開済み（published）」のすべての投稿を取得
    @shop_tags = ShopTag.all
  end

  def show
    @post = Post.find(params[:id])
    @shop_tags = @post.shop_tags.pluck(:name).join(',')
    @post_shop_tags = @post.shop_tags
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    @shop_tags = @post.shop_tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])

    shop_tags = params[:post][:name].split(',')
    #添付画像を個別に削除
    if params[:post][:image_ids]
      params[:post][:image_ids].each do |image_id|
        image = @post.images.find(image_id)
        image.purge
      end
    end

    if @post.update(post_params)
       @post.save_shop_tags(shop_tags)
      flash[:notice] = "変更に成功しました！"
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end

  # タグ
  def search_tag
    # 検索結果画面でもタグ一覧表示
     @shop_tags = ShopTag.all
    #検索されたタグを受け取る
     @search_shop_tag = ShopTag.find(params[:shop_tag_id])
    #検索されたタグに紐づく投稿を表示
     @shop_tag_post_results = @search_shop_tag.posts.published
    

  end

  # 検索機能（キーワード、タグ）
  def search
    @keywords = params[:keywords] #検索ワードを格納
    @search_results = Post.published.search_by_keywords(@keywords)#公開済み（published）」のすべての投稿を検索結果を格納
  end

  # 投稿データのストロングパラメータ
  private

  def post_params
    params.require(:post).permit(:shop_name, :shop_introduction, :shop_postal_code, :shop_address, :stay_weekday, :stay_time_start, :stay_time_end, :congestion_degree, :admin, :save_status, images: [])
  end

end


