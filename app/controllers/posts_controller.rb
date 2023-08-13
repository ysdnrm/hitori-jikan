class PostsController < ApplicationController
    
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    # current_user は、ログイン中のユーザーの情報を取得できる便利な記述(devise を導入しないと使用することができない)
    @post.user_id = current_user.id
   if @post.save
      redirect_to post_path(@post)
   else
      render :new
   end  
  end

  def index
    # 1ページ分の決められた数のデータだけを、新しい順に取得するように変更
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
    # @post_comment = PostComment.new
    #byebug
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end
  
  
  # 投稿データのストロングパラメータ
  private

  def post_params
    params.require(:post).permit(:shop_name, :shop_introduction, :shop_postal_code, :shop_address, :stay_weekday, :stay_time_start, :stay_time_end, :congestion_degree, images: [])
  end
  
end


