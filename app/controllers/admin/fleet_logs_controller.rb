class Admin::FleetLogsController < Admin::BaseController
  before_action :set_vehicle

  def create
    @log = @vehicle.fleet_logs.build(log_params)
    @log.logged_at ||= Time.current
    if @log.save
      @vehicle.update_column(:current_mileage, @log.mileage) if @log.mileage.present?
      redirect_to admin_fleet_vehicle_path(@vehicle), notice: "Log entry added."
    else
      redirect_to admin_fleet_vehicle_path(@vehicle), alert: "Could not save log: #{@log.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @vehicle.fleet_logs.find(params[:id]).destroy
    redirect_to admin_fleet_vehicle_path(@vehicle), notice: "Log entry deleted."
  end

  private

  def set_vehicle
    @vehicle = FleetVehicle.find(params[:fleet_vehicle_id])
  end

  def log_params
    params.require(:fleet_log).permit(:log_type, :description, :logged_at, :mileage, :cost, :performed_by, :notes)
  end
end
