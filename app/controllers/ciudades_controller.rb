class CiudadesController < ApplicationController
  before_action :set_ciudad, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token, only: %i[importacion_masiva]

  caches_action :index,
                expires_in: LONG_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath }

  caches_action :search,
                expires_in: LONG_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath }

  # GET /ciudades
  # GET /ciudades.json
  def index
    respond_to do |format|
      format.json do
        @ciudades = Ciudad.all_cached_and_ordered
        render(:index, ciudades: @ciudades)
      end
      format.html do
        @filterrific = initialize_filterrific(
          Ciudad.order(id: :asc),
          params[:filterrific],
          select_options: {}
        )
        @ciudades = @filterrific.try(:find) || Ciudad.order(id: :asc)
        @ciudades = @ciudades.page(params[:page])
        alert_new_ciudades
      end
    end
  end

  def search
    return unless params.key?(:term) && params[:term].length >= 3

    @ciudades = Ciudad.search(params[:term])
    render "ciudades/index_con_provincia.json"
  end

  # # GET /ciudades/1
  # # GET /ciudades/1.json
  def show
  end

  # GET /ciudades/new
  def new
    @ciudad = Ciudad.new
    authorize @ciudad, policy_class: GeoPolicy
  end

  # GET /ciudades/1/edit
  def edit
    authorize @ciudad, policy_class: GeoPolicy
  end

  # POST /ciudades
  # POST /ciudades.json
  def create
    @ciudad = Ciudad.new(ciudad_params)
    authorize @ciudad, policy_class: GeoPolicy

    respond_to do |format|
      if @ciudad.save
        format.html { redirect_to new_ciudad_path, notice: "Ciudad satisfactoriamente creada." }
        format.json { render :show, status: :created, location: @ciudad }
      else
        format.html { render :new }
        format.json { render json: @ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ciudades/1
  # PATCH/PUT /ciudades/1.json
  def update
    authorize @ciudad, policy_class: GeoPolicy
    respond_to do |format|
      if @ciudad.update(ciudad_params)
        format.html { redirect_to ciudades_path, notice: "Ciudad satisfactoriamente actualizada." }
        format.json { render :show, status: :ok, location: @ciudad }
      else
        format.html { render :edit }
        format.json { render json: @ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ciudades/1
  # DELETE /ciudades/1.json
  def destroy
    authorize @ciudad, policy_class: GeoPolicy
    @ciudad.destroy
    respond_to do |format|
      format.html { redirect_to ciudades_url, notice: "Ciudad satisfactoriamente eliminada." }
      format.json { head :no_content }
    end
  end

  # GET ciudades/importacion_masiva
  def new_importacion_masiva
  end

  # POST ciudades/importacion_masiva
  def importacion_masiva
    if params[:archivo].nil?
      redirect_to(ciudades_importacion_masiva_path) && return
    end
    @ciudades_import = CiudadesImport.new(file: params[:archivo])
    @msje = ""
    authorize @ciudades_import, policy_class: GeoPolicy
    if (res = @ciudades_import.save)[:cant].to_i > 0
      redirect_to ciudades_path, notice: "#{res[:cant]} ciudades importadas satisfactoriamente: \n#{res[:msje_success]}", alert: res[:msje_error]
    else
      redirect_to ciudades_importacion_masiva_path, alert: "Ninguna ciudad importada. #{res[:msje_error]}"
    end
  end

  private

  # Busca ciudades con usuarios activos y sin popular
  def alert_new_ciudades
    @ciudades_alert = Ciudad.joins(:users)
                            .distinct
                            .where(populada: false)
                            .pluck(:nombre, :id)
  end

  #   # Use callbacks to share common setup or constraints between actions.
  def set_ciudad
    @ciudad = Ciudad.find(params[:id])
  end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  def ciudad_params
    params.require(:ciudad).permit(:nombre, :provincia_id)
  end
end
