module Community
  class TipsController < BaseController
    def new
      @tip = CommunityTip.new
    end

    def create
      @tip = CommunityTip.new(tip_params)
      if @tip.save
        redirect_to community_root_path,
          notice: "Your tip has been received anonymously. Thank you for helping keep our community safe."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def tip_params
      params.require(:community_tip).permit(:tip_type, :description, :location)
    end
  end
end
