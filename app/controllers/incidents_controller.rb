class IncidentsController < ApplicationController
  before_action :set_incident, only: %i[ show edit update destroy ]

  # GET /incidents or /incidents.json
  def index
    @incidents = Incident.order(occurred_at: :desc)
    @incidents = @incidents.where("report_number LIKE ?", "%#{params[:report_number]}%") if params[:report_number].present?
    @incidents = @incidents.where(incident_type: params[:incident_type])                 if params[:incident_type].present?
    @incidents = @incidents.where(status: params[:status])                               if params[:status].present?
    if params[:location].present?
      term = "%#{params[:location]}%"
      @incidents = @incidents.where(
        "street_address LIKE ? OR city LIKE ? OR state LIKE ? OR zip_code LIKE ?",
        term, term, term, term
      )
    end
    if params[:occurred_date].present?
      begin
        day = Date.parse(params[:occurred_date])
        @incidents = @incidents.where(occurred_at: day.beginning_of_day..day.end_of_day)
      rescue ArgumentError
        nil
      end
    end
  end

  # GET /incidents/1 or /incidents/1.json
  def show
  end

  # GET /incidents/new
  def new
    @incident = Incident.new
  end

  # GET /incidents/1/edit
  def edit
  end

  # POST /incidents or /incidents.json
  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to @incident, notice: "Incident was successfully created." }
        format.json { render :show, status: :created, location: @incident }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incidents/1 or /incidents/1.json
  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to @incident, notice: "Incident was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @incident }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incidents/1 or /incidents/1.json
  def destroy
    @incident.destroy!

    respond_to do |format|
      format.html { redirect_to incidents_path, notice: "Incident was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident
      @incident = Incident.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def incident_params
      params.expect(incident: [ :report_number, :incident_type, :status, :street_address, :city, :state, :zip_code, :latitude, :longitude, :occurred_at, :reported_at, :narrative ])
    end
end
