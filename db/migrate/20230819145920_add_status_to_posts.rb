class AddStatusToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :save_status, :integer, default: 0, null: false
  end
end
