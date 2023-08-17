class UsersController < ApplicationController
  # 各アクションを実行する前に実行したい処理を指定(before_action)
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action user_admin, only: [:index]

  
  def index
    # 管理者用
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)

  end

  private
  
  def user_params
    params.require(:user).permit(:name, :profile_image, :email, :introduction)
  end
  
  def user_admin
    @users = User.all
    if  current_user.admin == false
        redirect_to root_path
    else
        render action: "index"
    end
  end
  
  # 他のユーザーからのアクセス制限(is_matching_login_userというメソッドにまとめる)
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end

end
