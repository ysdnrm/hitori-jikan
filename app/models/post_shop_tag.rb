class PostShopTag < ApplicationRecord
  belongs_to :post
  belongs_to :shop_tag
end
