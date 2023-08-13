class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,              null: false
      t.string :shop_name,             null: false
      t.text :shop_introduction,       null: false
      t.string :shop_postal_code,      null: false
      t.string :shop_address,          null: false
      t.integer :stay_weekday,         null: false, default: "0"
      t.integer :stay_time_start,      null: false
      t.integer :stay_time_end,        null: false
      t.integer :congestion_degree,    null: false, default: "0"
      t.timestamps
    end
  end
end
