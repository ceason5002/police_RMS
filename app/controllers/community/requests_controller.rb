module Community
  class RequestsController < BaseController
    def new
      @community_request = CommunityRequest.new
    end

    def create
      @community_request = CommunityRequest.new(request_params)
      if @community_request.save
        redirect_to community_root_path,
          notice: "Your request has been submitted. Reference #CR-#{@community_request.id}. We will review it shortly."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def request_params
      params.require(:community_request).permit(
        :request_type, :description, :location,
        :contact_name, :contact_email, :contact_phone, :photo
      )
    end
  end
end
