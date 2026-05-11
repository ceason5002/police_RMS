class ArrestsController < ApplicationController
  before_action :set_arrest, only: %i[ show edit update destroy ]

  # GET /arrests or /arrests.json
  def index
    @arrests = Arrest.all
  end

  # GET /arrests/1 or /arrests/1.json
  def show
  end

  # GET /arrests/new
  def new
    @arrest = Arrest.new
  end

  # GET /arrests/1/edit
  def edit
  end

  # POST /arrests or /arrests.json
  def create
    @arrest = Arrest.new(arrest_params)

    respond_to do |format|
      if @arrest.save
        format.html { redirect_to @arrest, notice: "Arrest was successfully created." }
        format.json { render :show, status: :created, location: @arrest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @arrest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arrests/1 or /arrests/1.json
  def update
    respond_to do |format|
      if @arrest.update(arrest_params)
        format.html { redirect_to @arrest, notice: "Arrest was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @arrest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @arrest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arrests/1 or /arrests/1.json
  def destroy
    @arrest.destroy!

    respond_to do |format|
      format.html { redirect_to arrests_path, notice: "Arrest was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_arrest
      @arrest = Arrest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def arrest_params
      params.expect(arrest: [ :incident_id, :person_id, :charges, :arrested_at, :mugshot ])
    end
end
