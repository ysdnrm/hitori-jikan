class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :shop_name
      t.text :caption
      t.string :postal_code,      null: false
      t.string :address,          null: false
      t.timestamps
    end
  end
end
