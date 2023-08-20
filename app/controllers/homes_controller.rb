class HomesController < ApplicationController
  def top
    @posts = Post.all
    # 新着商品（４つ
    @posts_latest4 = @posts.first(4)
  end
  
  def about
  end
  
  
  private

  def set_post
    # PATHパラメータでitemを取得
    @post = Post.find_by(params[:post_id])
  end

end
