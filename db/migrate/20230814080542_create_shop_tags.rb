class CreateShopTags < ActiveRecord::Migration[6.1]
  def change
    create_table :shop_tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    # 同じタグは２回保存出来ない
    add_index :shop_tags, :name, unique: true
  end
end
