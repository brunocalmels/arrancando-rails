class PaisesController < ApplicationController
  before_action :set_pais, only: %i[show edit update destroy]

  # GET /paises
  # GET /paises.json
  def index
    @filterrific = initialize_filterrific(Pais.order(id: :asc), params[:filterrific], select_options: {})

    @paises = @filterrific.try(:find) || Pais.order(id: :asc)
    @paises = @paises.page(params[:page])
  end

  # GET /paises/1
  # GET /paises/1.json
  def show
  end

  # GET /paises/new
  def new
    @pais = Pais.new
    authorize @pais, policy_class: GeoPolicy
  end

  # GET /paises/1/edit
  def edit
    authorize @pais, policy_class: GeoPolicy
  end

  # POST /paises
  # POST /paises.json
  def create
    @pais = Pais.new(pais_params)
    authorize @pais, policy_class: GeoPolicy

    respond_to do |format|
      if @pais.save
        format.html { redirect_to new_pais_path, notice: "País fue satisfactoriamente creado." }
        format.json { render :show, status: :created, location: @pais }
      else
        format.html { render :new }
        format.json { render json: @pais.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paises/1
  # PATCH/PUT /paises/1.json
  def update
    authorize @pais, policy_class: GeoPolicy
    respond_to do |format|
      if @pais.update(pais_params)
        format.html { redirect_to paises_path, notice: "País fue satisfactoriamente actualizado." }
        format.json { render :show, status: :ok, location: @pais }
      else
        format.html { render :edit }
        format.json { render json: @pais.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paises/1
  # DELETE /paises/1.json
  def destroy
    authorize @pais, policy_class: GeoPolicy
    @pais.destroy
    respond_to do |format|
      format.html { redirect_to paises_url, notice: "País fue satisfactoriamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pais
    @pais = Pais.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pais_params
    params.require(:pais).permit(:nombre)
  end
end
