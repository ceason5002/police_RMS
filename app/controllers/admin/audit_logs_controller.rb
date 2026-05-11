class Admin::AuditLogsController < Admin::BaseController
  def index
    @logs = AuditLog.recent.includes(:user)
    @logs = @logs.where(action: params[:action_filter])        if params[:action_filter].present?
    @logs = @logs.where(resource_type: params[:resource_type]) if params[:resource_type].present?
    @logs = @logs.where(user_id: params[:user_id])             if params[:user_id].present?
    @logs = @logs.limit(200)
  end
end