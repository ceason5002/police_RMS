class Admin::OfficerTrainingsController < Admin::BaseController
  before_action :set_training, only: [:show, :edit, :update, :destroy]

  def index
    @trainings = OfficerTraining.includes(:officer)
    @trainings = @trainings.where(officer_id: params[:officer_id]) if params[:officer_id].present?
    @trainings = @trainings.where(status: params[:status]) if params[:status].present?
    @trainings = @trainings.where(training_type: params[:training_type]) if params[:training_type].present?
    @trainings = @trainings.order(created_at: :desc)
    @officers  = Officer.active.order(:last_name)
  end

  def show; end

  def new
    @training = OfficerTraining.new(officer_id: params[:officer_id])
    @officers = Officer.active.order(:last_name)
  end

  def create
    @training = OfficerTraining.new(training_params)
    if @training.save
      redirect_to admin_officer_trainings_path, notice: "Training record added."
    else
      @officers = Officer.active.order(:last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @officers = Officer.active.order(:last_name)
  end

  def update
    if @training.update(training_params)
      redirect_to admin_officer_trainings_path, notice: "Training record updated."
    else
      @officers = Officer.active.order(:last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @training.destroy
    redirect_to admin_officer_trainings_path, notice: "Training record deleted."
  end

  private

  def set_training
    @training = OfficerTraining.find(params[:id])
  end

  def training_params
    params.require(:officer_training).permit(:officer_id, :training_type, :title, :status,
                                              :completed_on, :expires_on, :hours, :instructor, :notes)
  end
end
