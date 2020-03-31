class PoisController < ApplicationController
  include ContentHelper
  before_action :set_poi, only: %i[show edit update destroy puntuar]

  # GET /pois
  # GET /pois.json
  def index
    @filterrific = initialize_filterrific(Poi, params[:filterrific], select_options: {})
    @pois = policy_scope(@filterrific.try(:find) || Poi)

    if request.format.json? && !params.include?("filterrific")
      filter_by_categria_poi_id
      filter_by_term
      filter_habilitados
    end

    fetch_items

    render :index
  end

  # GET /pois/1
  # GET /pois/1.json
  def show
  end

  # GET /pois/search
  # GET /pois/search.json
  def search
    index
  end

  # GET /pois/new
  def new
    @poi = Poi.new
  end

  # GET /pois/1/edit
  def edit
    authorize @poi
  end

  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/AbcSize
  # POST /pois
  # POST /pois.json
  def create
    @poi = Poi.new(poi_params)
    # @poi.geo_point = "POINT(#{poi_params['long']} #{poi_params['lat']})"
    @poi.user = current_user

    inferir_ciudad if request.format.json?

    respond_to do |format|
      format.html do
        if (params[:poi][:imagenes].nil? || save_images_html(params, @poi, :poi)) && @poi.valid? && @poi.save
          redirect_to new_poi_path, notice: "PoI satisfactoriamente creado."
        else
          render :new
        end
      end
      format.json do
        if params[:imagenes].nil? || params[:imagenes].class == Array && save_images_json(params, @poi) && @poi.valid? && @poi.save
          render :show, status: :created, location: @poi
        else
          render json: @poi.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /pois/1
  # PATCH/PUT /pois/1.json
  def update
    authorize @poi
    respond_to do |format|
      format.html do
        if @poi.update(poi_params) && (params[:poi][:imagenes].nil? && params["remove_imagenes"].nil? || update_images_html(params, @poi, :poi))
          redirect_to @poi, notice: "PoI satisfactoriamente actualizado."
        else
          render :edit
        end
      end
      format.json do
        if @poi.update(poi_params) && (params[:imagenes].nil? && params["remove_imagenes"].nil? || update_images_json(params, @poi))
          render :show, status: :ok, location: @poi
        else
          render json: @poi.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # rubocop: enable Metrics/AbcSize
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/PerceivedComplexity

  # DELETE /pois/1
  # DELETE /pois/1.json
  def destroy
    authorize @poi
    @poi.destroy
    respond_to do |format|
      format.html { redirect_to pois_url, notice: "Poi satisfactoriamente eliminado." }
      format.json { head :no_content }
    end
  end

  def puntuar
    puntuar_obj(@poi)
  end

  private

  def filter_by_categria_poi_id
    return unless params.key? :categoria_poi_id

    @pois = @pois
            .where(categoria_poi_id: params[:categoria_poi_id].to_i)
  end

  def filter_by_term
    return unless params.key? :term

    @pois = @pois
            .search(params[:term])
  end

  def filter_habilitados
    @pois = @pois.habilitados
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_poi
    @poi = Poi.find(params[:id])
  end

  def fetch_items
    @pois = @pois
            .order(titulo: :asc)
            .limit(params.key?(:limit) ? params[:limit].to_i : 10)

    return if params[:limit] && request.format.json?

    @pois = @pois.page(params[:page])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def poi_params
    if request.format.json?
      params.require(:poi).permit(:titulo, :cuerpo, :lat, :long, :direccion, :categoria_poi_id)
    else
      params.require(:poi).permit(:titulo, :cuerpo, :lat, :long, :direccion, :categoria_poi_id, :habilitado, :user_id, :ciudad_id)
    end
  end

  def inferir_provincia
    @provincia = Provincia.find_by_nombre(params[:nombre_provincia])
    return unless @provincia.nombre == "Buenos Aires"

    @provincia2 = Provincia.find_by_nombre("Capital Federal")
  end

  def inferir_ciudad
    return unless params.key?(:nombre_ciudad) && params.key?(:nombre_provincia)

    inferir_provincia

    ciudad = Ciudad.find_by_nombre(params[:nombre_ciudad])
    unless ciudad.provincia_id == @provincia.id || (@provincia2 && ciudad.provincia_id == @provincia2.id)
      return
    end

    @poi.ciudad = ciudad
  end
end
