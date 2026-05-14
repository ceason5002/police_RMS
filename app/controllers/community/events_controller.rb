module Community
  class EventsController < BaseController
    def index
      @upcoming = CommunityEvent.upcoming
      @past     = CommunityEvent.past.limit(6)
    end

    def show
      @event = CommunityEvent.published.find(params[:id])
    end
  end
end
