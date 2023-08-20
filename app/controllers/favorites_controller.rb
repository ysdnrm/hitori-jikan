class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy] # ログインユーザーのみ許可
  
  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    # redirect_to post_path(@post) # 非同期処理のため消す
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
    # redirect_to post_path(@post) # 非同期処理のため消す。
  end

  private

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "いいねをするにはログインが必要です。"
      redirect_to new_user_session_path
    end
  end

end
