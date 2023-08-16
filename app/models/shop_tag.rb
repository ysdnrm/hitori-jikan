class ShopTag < ApplicationRecord
  has_many :post_shop_tags, dependent: :destroy
  has_many :posts, through: :post_shop_tags
  
  validates :name, presence:true, length:{maximum:50}
end
