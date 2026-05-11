class Admin::UnitsController < Admin::BaseController
  before_action :set_unit, only: %i[show edit update destroy]

  def index  = @units  = Unit.includes(:officers).order(:name)
  def show   = @officers = @unit.officers.order(:last_name)
  def new    = render(:new,  locals: { unit: Unit.new })
  def edit   = render(:edit, locals: { unit: @unit })

  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      audit("created", @unit)
      redirect_to admin_units_path, notice: "Unit created."
    else
      render :new, locals: { unit: @unit }, status: :unprocessable_entity
    end
  end

  def update
    if @unit.update(unit_params)
      audit("updated", @unit)
      redirect_to admin_units_path, notice: "Unit updated."
    else
      render :edit, locals: { unit: @unit }, status: :unprocessable_entity
    end
  end

  def destroy
    @unit.destroy!
    redirect_to admin_units_path, notice: "Unit deleted."
  end

  private

  def set_unit    = @unit = Unit.find(params[:id])
  def unit_params = params.expect(unit: [:name, :unit_type, :description])
end