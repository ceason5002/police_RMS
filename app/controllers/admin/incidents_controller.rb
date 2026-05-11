class Admin::IncidentsController < Admin::BaseController
  before_action :set_incident, only: %i[show edit update toggle_flag]

  def index
    @incidents = Incident.order(occurred_at: :desc)
    @incidents = @incidents.where(status: params[:status])              if params[:status].present?
    @incidents = @incidents.where(incident_type: params[:incident_type]) if params[:incident_type].present?
    @incidents = @incidents.where(flagged: true)                         if params[:flagged] == "1"
    if params[:date_from].present?
      @incidents = @incidents.where("occurred_at >= ?", params[:date_from])
    end
    if params[:date_to].present?
      @incidents = @incidents.where("occurred_at <= ?", "#{params[:date_to]} 23:59:59")
    end
  end

  def show; end

  def edit; end

  def update
    if @incident.update(incident_params)
      audit("updated", @incident)
      redirect_to admin_incident_path(@incident), notice: "Incident updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_flag
    new_state = !@incident.flagged
    @incident.update!(
      flagged:        new_state,
      flagged_reason: new_state ? params[:reason].presence : nil
    )
    audit(new_state ? "flagged" : "unflagged", @incident)
    redirect_to admin_incidents_path, notice: "Incident #{new_state ? 'flagged' : 'unflagged'}."
  end

  private

  def set_incident    = @incident = Incident.find(params[:id])
  def incident_params = params.expect(incident: [:status, :crime_case_id, :flagged, :flagged_reason])
end