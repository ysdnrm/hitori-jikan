class PostShopTag < ApplicationRecord
  # 中間テーブル
  belongs_to :post
  belongs_to :shop_tag
end
