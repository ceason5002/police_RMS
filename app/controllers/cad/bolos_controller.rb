module Cad
  class BolosController < BaseController
    before_action :set_bolo, only: [:show, :edit, :update, :destroy, :cancel, :resolve]

    def index
      @active_bolos = Bolo.active.includes(:issuing_officer, :created_by).recent
      @past_bolos   = Bolo.where.not(status: "Active").includes(:issuing_officer).recent
    end

    def show
    end

    def new
      @bolo = Bolo.new(status: "Active")
    end

    def create
      @bolo = Bolo.new(bolo_params)
      @bolo.created_by = current_user
      if @bolo.save
        redirect_to cad_bolo_path(@bolo), notice: "BOLO issued and broadcast."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @bolo.update(bolo_params)
        redirect_to cad_bolo_path(@bolo), notice: "BOLO updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @bolo.destroy
      redirect_to cad_bolos_path, notice: "BOLO removed."
    end

    def cancel
      @bolo.update!(status: "Cancelled")
      redirect_to cad_bolos_path, notice: "BOLO cancelled."
    end

    def resolve
      @bolo.update!(status: "Resolved")
      redirect_to cad_bolos_path, notice: "BOLO resolved."
    end

    private

    def set_bolo
      @bolo = Bolo.find(params[:id])
    end

    def bolo_params
      params.require(:bolo).permit(
        :subject_description, :vehicle_description, :last_known_location,
        :issuing_officer_id, :expires_at, :status
      )
    end
  end
end
