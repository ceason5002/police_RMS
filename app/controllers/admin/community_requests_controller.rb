class Admin::CommunityRequestsController < Admin::BaseController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :resolve, :assign]

  def index
    @status_filter = params[:status]
    scope = @status_filter.present? ? CommunityRequest.where(status: @status_filter) : CommunityRequest.all
    @community_requests = scope.recent
  end

  def show; end

  def edit; end

  def update
    if @community_request.update(request_params)
      redirect_to admin_community_request_path(@community_request), notice: "Request updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @community_request.destroy
    redirect_to admin_community_requests_path, notice: "Request deleted."
  end

  def resolve
    @community_request.update!(status: "Resolved")
    redirect_to admin_community_request_path(@community_request), notice: "Marked as Resolved."
  end

  def assign
    if params[:incident_id].present?
      incident = Incident.find(params[:incident_id])
      @community_request.update!(incident: incident, status: "Assigned")
      redirect_to admin_community_request_path(@community_request), notice: "Linked to incident ##{incident.report_number}."
    else
      redirect_to admin_community_request_path(@community_request), alert: "Select an incident."
    end
  end

  private

  def set_request
    @community_request = CommunityRequest.find(params[:id])
  end

  def request_params
    params.require(:community_request).permit(:status, :internal_notes, :incident_id)
  end
end
