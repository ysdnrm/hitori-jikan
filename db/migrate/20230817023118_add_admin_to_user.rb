class AddAdminToUser < ActiveRecord::Migration[6.1]
  def change
    # 管理者権限
    add_column :users, :admin, :boolean, default: false 
  end
end
