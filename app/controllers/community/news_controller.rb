module Community
  class NewsController < BaseController
    def index
      @pagy, @posts = pagy(NewsPost.published, limit: 10)
    end

    def show
      @post = NewsPost.published.find(params[:id])
    end
  end
end
