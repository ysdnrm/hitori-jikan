class PostsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    # current_user は、ログイン中のユーザーの情報を取得できる便利な記述(devise を導入しないと使用することができない)
    @post.user_id = current_user.id
     # 受け取った値を,で区切って配列にする
    tag_list = params[:post][:name].split(',')
    if @post.save
      @post.save_shop_tags(tag_list)
      redirect_to post_path(@post)
    else
      # redirect_to new_post_path
      render "new"
    end
  end

  def index
    @posts = Post.all
    @tag_list = ShopTag.all
  end

  def show
    @post = Post.find(params[:id])
    @tag_list = @post.shop_tags.pluck(:name).join(',')
    @post_shop_tags = @post.shop_tags
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.shop_tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])

    tag_list = params[:post][:name].split(',')
    #添付画像を個別に削除
    if params[:post][:image_ids]
      params[:post][:image_ids].each do |image_id|
        image = @post.images.find(image_id)
        image.purge
      end
    end

    if @post.update(post_params)
       @post.save_shop_tags(tag_list)
      flash[:notice] = "変更に成功しました！"
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = ShopTag.all
    #検索されたタグを受け取る
    @tag = ShopTag.find(params[:shop_tag_id])
    #検索されたタグに紐づく投稿を表示
    @posts = @tag.posts
  end

  # 投稿データのストロングパラメータ
  private

  def post_params
    params.require(:post).permit(:shop_name, :shop_introduction, :shop_postal_code, :shop_address, :stay_weekday, :stay_time_start, :stay_time_end, :congestion_degree, :admin, images: [])
  end

end


