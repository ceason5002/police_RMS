class Admin::OfficerComplaintsController < Admin::BaseController
  before_action :set_complaint, only: [:show, :edit, :update, :destroy]

  def index
    @complaints = OfficerComplaint.includes(:officer)
    @complaints = @complaints.where(status: params[:status]) if params[:status].present?
    @complaints = @complaints.recent
  end

  def show; end

  def new
    @complaint = OfficerComplaint.new
    @officers  = Officer.active.order(:last_name)
  end

  def create
    @complaint = OfficerComplaint.new(complaint_params)
    if @complaint.save
      redirect_to admin_officer_complaints_path, notice: "Complaint recorded."
    else
      @officers = Officer.active.order(:last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @officers = Officer.active.order(:last_name)
  end

  def update
    if @complaint.update(complaint_params)
      redirect_to admin_officer_complaint_path(@complaint), notice: "Complaint updated."
    else
      @officers = Officer.active.order(:last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @complaint.destroy
    redirect_to admin_officer_complaints_path, notice: "Complaint deleted."
  end

  private

  def set_complaint
    @complaint = OfficerComplaint.find(params[:id])
  end

  def complaint_params
    params.require(:officer_complaint).permit(:complainant_name, :complainant_contact,
                                               :incident_date, :complaint_type, :description,
                                               :status, :internal_notes, :assigned_investigator,
                                               :officer_id, :received_at)
  end
end
