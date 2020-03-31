class ProvinciasController < ApplicationController
  before_action :set_provincia, only: %i[show edit update destroy]

  # GET /provincias
  # GET /provincias.json
  def index
    @filterrific = initialize_filterrific(Provincia.order(id: :asc), params[:filterrific], select_options: {})
    @provincias = @filterrific.try(:find) || Provincia.order(id: :asc)
    @provincias = @provincias.page(params[:page])
  end

  # GET /provincias/1
  # GET /provincias/1.json
  def show
  end

  # GET /provincias/new
  def new
    @provincia = Provincia.new
    authorize @provincia, policy_class: GeoPolicy
  end

  # GET /provincias/1/edit
  def edit
    authorize @provincia, policy_class: GeoPolicy
  end

  # POST /provincias
  # POST /provincias.json
  def create
    @provincia = Provincia.new(provincia_params)
    authorize @provincia, policy_class: GeoPolicy

    respond_to do |format|
      if @provincia.save
        format.html { redirect_to new_provincia_path, notice: "Provincia satisfactoriamente creada." }
        format.json { render :show, status: :created, location: @provincia }
      else
        format.html { render :new }
        format.json { render json: @provincia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provincias/1
  # PATCH/PUT /provincias/1.json
  def update
    authorize @provincia, policy_class: GeoPolicy
    respond_to do |format|
      if @provincia.update(provincia_params)
        format.html { redirect_to provincias_path, notice: "Provincia satisfactoriamente actualizada." }
        format.json { render :show, status: :ok, location: @provincia }
      else
        format.html { render :edit }
        format.json { render json: @provincia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provincias/1
  # DELETE /provincias/1.json
  def destroy
    authorize @provincia, policy_class: GeoPolicy
    @provincia.destroy
    respond_to do |format|
      format.html { redirect_to provincias_url, notice: "Provincia satisfactoriamente eliminada." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_provincia
    @provincia = Provincia.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def provincia_params
    params.require(:provincia).permit(:nombre, :pais_id)
  end
end
