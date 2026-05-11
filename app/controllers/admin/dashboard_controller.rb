class Admin::DashboardController < Admin::BaseController
  def index
    @open_cases       = CrimeCase.where(status: "Open").count
    @closed_cases     = CrimeCase.where(status: "Closed").count
    @incidents_today  = Incident.where("DATE(occurred_at) = DATE(?)", Date.today).count
    @active_officers  = Officer.active.count
    @recent_activity  = AuditLog.recent.includes(:user).limit(15)
    @flagged_incidents = Incident.where(flagged: true).count
    @open_incidents   = Incident.where(status: "Open").count
  end
end