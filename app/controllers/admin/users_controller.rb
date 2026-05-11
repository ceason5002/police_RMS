class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy toggle_active]

  def index  = @users = User.includes(:officer).order(:login_id)
  def show;  end
  def new    = render(:new, locals: { user: User.new })
  def edit;  end

  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(12) unless user_params[:password].present?
    if @user.save
      audit("created", @user, details: "ID: #{@user.login_id}, Role: #{@user.role}")
      redirect_to admin_users_path, notice: "User created. They can reset their password via login page."
    else
      render :new, locals: { user: @user }, status: :unprocessable_entity
    end
  end

  def update
    params_to_use = user_params
    params_to_use = params_to_use.except(:password, :password_confirmation) if params_to_use[:password].blank?
    if @user.update(params_to_use)
      audit("updated", @user)
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: "User deleted."
  end

  def toggle_active
    @user.update!(active: !@user.active)
    status = @user.active? ? "activated" : "deactivated"
    audit(status, @user)
    redirect_to admin_users_path, notice: "User #{status}."
  end

  private

  def set_user    = @user = User.find(params[:id])
  def user_params = params.expect(user: [:login_id, :password, :password_confirmation, :role, :officer_id, :active])
end