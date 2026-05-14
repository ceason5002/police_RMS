module Community
  class BolosController < BaseController
    def index
      @active_bolos = Bolo.active.order(created_at: :desc)
      @past_bolos   = Bolo.where(status: "Resolved").order(updated_at: :desc).limit(10)
    end
  end
end
