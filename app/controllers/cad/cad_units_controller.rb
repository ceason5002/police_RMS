module Cad
  class CadUnitsController < BaseController
    before_action :set_unit, only: [:show, :edit, :update, :destroy, :change_status]

    def index
      @units = CadUnit.includes(:assigned_officer).by_number
      @units = @units.where(status: params[:status])      if params[:status].present?
      @units = @units.where(unit_type: params[:unit_type]) if params[:unit_type].present?
    end

    def show
      @status_logs  = @unit.unit_status_logs.recent.includes(:changed_by).limit(25)
      @active_calls = @unit.cad_calls.where.not(status: "Cleared").includes(:call_notes)
    end

    def new
      @unit = CadUnit.new(status: "Available")
    end

    def create
      @unit = CadUnit.new(unit_params)
      if @unit.save
        @unit.unit_status_logs.create!(
          status:     @unit.status,
          changed_by: current_user,
          changed_at: Time.current
        )
        redirect_to cad_cad_unit_path(@unit), notice: "Unit #{@unit.unit_number} added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      old_status = @unit.status
      if @unit.update(unit_params)
        if @unit.status != old_status
          @unit.unit_status_logs.create!(
            status:     @unit.status,
            changed_by: current_user,
            changed_at: Time.current
          )
        end
        redirect_to cad_cad_unit_path(@unit), notice: "Unit #{@unit.unit_number} updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @unit.destroy
      redirect_to cad_cad_units_path, notice: "Unit removed."
    end

    def change_status
      new_status = params[:status]
      unless CadUnit::STATUSES.include?(new_status)
        redirect_to cad_cad_unit_path(@unit), alert: "Invalid status."
        return
      end
      @unit.change_status!(new_status, changed_by: current_user)
      redirect_to cad_cad_unit_path(@unit), notice: "#{@unit.unit_number} status → #{new_status}."
    end

    private

    def set_unit
      @unit = CadUnit.find(params[:id])
    end

    def unit_params
      params.require(:cad_unit).permit(:unit_number, :unit_type, :assigned_officer_id, :status)
    end
  end
end
