class CreatePostShopTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_shop_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :shop_tag, null: false, foreign_key: true

      t.timestamps
    end
    # 同じタグは２回保存出来ない
    add_index :post_shop_tags, [:post_id,:shop_tag_id],unique: true
  end
end
