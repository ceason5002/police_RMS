class Admin::NewsPostsController < Admin::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = NewsPost.recent
  end

  def new
    @post = NewsPost.new
  end

  def create
    @post = NewsPost.new(post_params)
    if @post.save
      redirect_to admin_news_posts_path, notice: "Post #{@post.published? ? 'published' : 'saved as draft'}."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to admin_news_posts_path, notice: "Post updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_news_posts_path, notice: "Post deleted."
  end

  private

  def set_post
    @post = NewsPost.find(params[:id])
  end

  def post_params
    params.require(:news_post).permit(:title, :body, :author_name, :status)
  end
end
