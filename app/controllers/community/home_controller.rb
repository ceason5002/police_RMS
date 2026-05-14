module Community
  class HomeController < BaseController
    def index
      @recent_news    = NewsPost.published.limit(3)
      @upcoming_events = CommunityEvent.upcoming.limit(4)
      @active_bolos   = Bolo.active.order(created_at: :desc).limit(3)
      @spotlight      = Officer.featured.where.not(spotlight_bio: [nil, ""]).first
      @open_requests_count = Incident.where(
        incident_type: "Missing Person", status: "Open"
      ).count
    end
  end
end
