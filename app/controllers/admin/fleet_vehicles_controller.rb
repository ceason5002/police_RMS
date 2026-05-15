class Admin::FleetVehiclesController < Admin::BaseController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = FleetVehicle.ordered
    @vehicles = @vehicles.where(status: params[:status]) if params[:status].present?
  end

  def show
    @logs = @vehicle.fleet_logs.recent.limit(50)
    @new_log = FleetLog.new(fleet_vehicle: @vehicle, logged_at: Time.current)
  end

  def new
    @vehicle = FleetVehicle.new
  end

  def create
    @vehicle = FleetVehicle.new(vehicle_params)
    if @vehicle.save
      redirect_to admin_fleet_vehicle_path(@vehicle), notice: "Vehicle added to fleet."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to admin_fleet_vehicle_path(@vehicle), notice: "Vehicle updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to admin_fleet_vehicles_path, notice: "Vehicle removed from fleet."
  end

  private

  def set_vehicle
    @vehicle = FleetVehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:fleet_vehicle).permit(:unit_number, :make, :model, :year, :vin,
                                           :color, :status, :current_mileage, :notes)
  end
end
