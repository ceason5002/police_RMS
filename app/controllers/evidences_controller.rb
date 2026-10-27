class EvidencesController < ApplicationController
  before_action :set_evidence, only: %i[ show edit update destroy ]

  # GET /evidences or /evidences.json
  def index
    @evidences = Evidence.order(collected_at: :desc).includes(:incident)
    @evidences = @evidences.where("evidence_number LIKE ?", "%#{params[:evidence_number]}%") if params[:evidence_number].present?
    @evidences = @evidences.where(status: params[:status]) if params[:status].present?
    @evidences = @evidences.where("location_stored LIKE ?", "%#{params[:location_stored]}%") if params[:location_stored].present?
    if params[:collected_date].present?
      begin
        day = Date.parse(params[:collected_date])
        @evidences = @evidences.where(collected_at: day.beginning_of_day..day.end_of_day)
      rescue ArgumentError
        nil
      end
    end
  end

  # GET /evidences/1 or /evidences/1.json
  def show
  end

  # GET /evidences/new
  def new
    @evidence = Evidence.new
  end

  # GET /evidences/1/edit
  def edit
  end

  # POST /evidences or /evidences.json
  def create
    @evidence = Evidence.new(evidence_params)

    respond_to do |format|
      if @evidence.save
        format.html { redirect_to @evidence, notice: "Evidence was successfully created." }
        format.json { render :show, status: :created, location: @evidence }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @evidence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evidences/1 or /evidences/1.json
  def update
    respond_to do |format|
      if @evidence.update(evidence_params)
        format.html { redirect_to @evidence, notice: "Evidence was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @evidence }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @evidence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evidences/1 or /evidences/1.json
  def destroy
    @evidence.destroy!

    respond_to do |format|
      format.html { redirect_to evidences_path, notice: "Evidence was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evidence
      @evidence = Evidence.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def evidence_params
      params.expect(evidence: [ :incident_id, :evidence_number, :description, :status, :location_stored, :chain_of_custody, :collected_at, :collected_by ])
    end
end
