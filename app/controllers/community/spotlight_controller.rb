module Community
  class SpotlightController < BaseController
    def index
      @officer = Officer.featured.where.not(spotlight_bio: [nil, ""]).first
    end
  end
end
