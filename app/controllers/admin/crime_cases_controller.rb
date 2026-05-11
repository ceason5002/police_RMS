class Admin::CrimeCasesController < Admin::BaseController
  before_action :set_case, only: %i[show edit update destroy close reopen]

  def index
    @cases = CrimeCase.includes(:lead_officer).order(created_at: :desc)
    @cases = @cases.where(status: params[:status]) if params[:status].present?
    @cases = @cases.where(lead_officer_id: params[:officer_id]) if params[:officer_id].present?
  end

  def show
    @incidents = @crime_case.incidents.order(occurred_at: :desc)
  end

  def new    = render(:new,  locals: { crime_case: CrimeCase.new })
  def edit   = render(:edit, locals: { crime_case: @crime_case })

  def create
    @crime_case = CrimeCase.new(crime_case_params)
    if @crime_case.save
      audit("created", @crime_case)
      redirect_to admin_crime_case_path(@crime_case), notice: "Case created."
    else
      render :new, locals: { crime_case: @crime_case }, status: :unprocessable_entity
    end
  end

  def update
    if @crime_case.update(crime_case_params)
      audit("updated", @crime_case)
      redirect_to admin_crime_case_path(@crime_case), notice: "Case updated."
    else
      render :edit, locals: { crime_case: @crime_case }, status: :unprocessable_entity
    end
  end

  def destroy
    @crime_case.destroy!
    redirect_to admin_crime_cases_path, notice: "Case deleted."
  end

  def close
    @crime_case.update!(status: "Closed")
    audit("closed", @crime_case)
    redirect_to admin_crime_case_path(@crime_case), notice: "Case closed."
  end

  def reopen
    @crime_case.update!(status: "Open")
    audit("reopened", @crime_case)
    redirect_to admin_crime_case_path(@crime_case), notice: "Case reopened."
  end

  private

  def set_case          = @crime_case = CrimeCase.find(params[:id])
  def crime_case_params = params.expect(crime_case: [:case_number, :title, :status, :description, :lead_officer_id])
end