class Admin::UsersController < ApplicationController
  # 管理ユーザー以外で特定のアクションを実行しようとした場合には、トップページにリダイレクトさせる
  before_action :if_not_admin
  
  def index
    @users = User.all
  end
  
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザーが削除されました。"
  end
  
  
private

  def user_params
    params.require(:user).permit(:name, :profile_image, :email, :introduction)
  end
  
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

end
