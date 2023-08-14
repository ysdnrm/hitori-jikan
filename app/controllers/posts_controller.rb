class PostsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]

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
      # redirect_to new_post_path
      render "new"
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

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "変更に成功しました！"
      redirect_to post_path(@post)
    else
      render 'show'
    end
  end


  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end


  # 投稿データのストロングパラメータ
  private

  def post_params
    params.require(:post).permit(:shop_name, :shop_introduction, :shop_postal_code, :shop_address, :stay_weekday, :stay_time_start, :stay_time_end, :congestion_degree, images: [])
  end

end


