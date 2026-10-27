class ArrestsController < ApplicationController
  before_action :set_arrest, only: %i[ show edit update destroy ]

  # GET /arrests or /arrests.json
  def index
    @arrests = Arrest.order(arrested_at: :desc).includes(:incident, :person)
    if params[:incident_number].present?
      @arrests = @arrests.joins(:incident).where("incidents.report_number LIKE ?", "%#{params[:incident_number]}%")
    end
    if params[:person_name].present?
      term = "%#{params[:person_name]}%"
      @arrests = @arrests.joins(:person).where("people.first_name LIKE ? OR people.last_name LIKE ?", term, term)
    end
    @arrests = @arrests.where("charges LIKE ?", "%#{params[:charges]}%") if params[:charges].present?
    if params[:arrested_date].present?
      begin
        day = Date.parse(params[:arrested_date])
        @arrests = @arrests.where(arrested_at: day.beginning_of_day..day.end_of_day)
      rescue ArgumentError
        nil
      end
    end
  end

  # GET /arrests/1 or /arrests/1.json
  def show
  end

  # GET /arrests/new
  def new
    @arrest = Arrest.new
  end

  # GET /arrests/1/edit
  def edit
  end

  # POST /arrests or /arrests.json
  def create
    @arrest = Arrest.new(arrest_params)

    respond_to do |format|
      if @arrest.save
        format.html { redirect_to @arrest, notice: "Arrest was successfully created." }
        format.json { render :show, status: :created, location: @arrest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @arrest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arrests/1 or /arrests/1.json
  def update
    respond_to do |format|
      if @arrest.update(arrest_params)
        format.html { redirect_to @arrest, notice: "Arrest was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @arrest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @arrest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arrests/1 or /arrests/1.json
  def destroy
    @arrest.destroy!

    respond_to do |format|
      format.html { redirect_to arrests_path, notice: "Arrest was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_arrest
      @arrest = Arrest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def arrest_params
      params.expect(arrest: [ :incident_id, :person_id, :charges, :arrested_at, :mugshot ])
    end
end
