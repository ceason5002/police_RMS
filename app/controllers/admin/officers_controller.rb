class Admin::OfficersController < Admin::BaseController
  before_action :set_officer, only: %i[show edit update destroy toggle_active]

  def index
    @officers = Officer.includes(:units).order(:last_name)
    @officers = @officers.where(active: params[:active] == "false" ? false : true) unless params[:active].nil? && !params.key?(:active)
    @officers = @officers.where(rank: params[:rank]) if params[:rank].present?
  end

  def show
    @cases = @officer.led_cases.order(created_at: :desc)
  end

  def new    = render(:new, locals: { officer: Officer.new })
  def edit   = render(:edit, locals: { officer: @officer })

  def create
    @officer = Officer.new(officer_params)
    if @officer.save
      audit("created", @officer)
      redirect_to admin_officer_path(@officer), notice: "Officer created."
    else
      render :new, locals: { officer: @officer }, status: :unprocessable_entity
    end
  end

  def update
    if @officer.update(officer_params)
      audit("updated", @officer)
      redirect_to admin_officer_path(@officer), notice: "Officer updated."
    else
      render :edit, locals: { officer: @officer }, status: :unprocessable_entity
    end
  end

  def destroy
    @officer.destroy!
    audit("deleted", @officer, details: "Badge #{@officer.badge_number}")
    redirect_to admin_officers_path, notice: "Officer removed."
  end

  def toggle_active
    @officer.update!(active: !@officer.active)
    status = @officer.active? ? "activated" : "deactivated"
    audit(status, @officer)
    redirect_to admin_officers_path, notice: "Officer #{status}."
  end

  private

  def set_officer   = @officer = Officer.find(params[:id])
  def officer_params = params.expect(officer: [:badge_number, :first_name, :last_name, :rank, :assignments, :active, unit_ids: []])
end