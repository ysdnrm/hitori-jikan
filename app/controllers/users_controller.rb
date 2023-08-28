class UsersController < ApplicationController
  # 各アクションを実行する前に実行したい処理を指定(before_action)
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :set_user, only: [:favorites]
  before_action :ensure_guest_user, only: [:edit]
  # before_action user_admin, only: [:index]


  def index
    # 管理者用
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.published
    @posts_page = @user.posts.published.page(params[:page]).per(8)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  # いいねした投稿一覧
  def favorites
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites) #いいねした投稿
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

  def set_user
    @user = User.find(params[:id])
  end


  # 他のユーザーからのアクセス制限(is_matching_login_userというメソッドにまとめる)
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end  
end
