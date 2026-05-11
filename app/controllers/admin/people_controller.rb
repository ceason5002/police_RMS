class Admin::PeopleController < Admin::BaseController
  before_action :set_person, only: %i[show edit update]

  def index
    @people = Person.order(:last_name)
    @people = @people.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
  end

  def show
    @arrests  = @person.arrests.includes(:incident).order(arrested_at: :desc)
    @vehicles = @person.vehicles.order(:make)
  end

  def edit; end

  def update
    if @person.update(person_params)
      audit("updated", @person)
      redirect_to admin_person_path(@person), notice: "Person updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_person    = @person = Person.find(params[:id])
  def person_params = params.expect(person: [:first_name, :last_name, :date_of_birth, :street_address, :city, :state, :zip_code, :notes])
end