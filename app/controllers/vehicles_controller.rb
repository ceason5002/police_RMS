class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show edit update destroy ]

  # GET /vehicles or /vehicles.json
  def index
    @vehicles = Vehicle.order(:plate_number).includes(:person)
    @vehicles = @vehicles.where("plate_number LIKE ?", "%#{params[:plate_number]}%") if params[:plate_number].present?
    @vehicles = @vehicles.where(make: params[:make]) if params[:make].present?
    @vehicles = @vehicles.where("color LIKE ?", "%#{params[:color]}%") if params[:color].present?
    if params[:owner_name].present?
      term = "%#{params[:owner_name]}%"
      @vehicles = @vehicles.joins(:person).where("people.first_name LIKE ? OR people.last_name LIKE ?", term, term)
    end
    @vehicle_makes = Vehicle.distinct.where.not(make: nil).order(:make).pluck(:make)
  end

  # GET /vehicles/1 or /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles or /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: "Vehicle was successfully created." }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to @vehicle, notice: "Vehicle was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1 or /vehicles/1.json
  def destroy
    @vehicle.destroy!

    respond_to do |format|
      format.html { redirect_to vehicles_path, notice: "Vehicle was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.expect(vehicle: [ :plate_number, :make, :model, :year, :color, :person_id ])
    end
end
