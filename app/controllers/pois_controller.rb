class PoisController < ApplicationController
  include ContentHelper
  include PoisHelper
  include NotificacionesHelper
  before_action :set_poi, only: %i[show edit update destroy puntuar saved]

  caches_action :index,
                expires_in: DEFAULT_INDEX_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath },
                if: -> { request.format.json? }

  caches_action :search,
                expires_in: DEFAULT_INDEX_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath },
                if: -> { request.format.json? }

  # GET /pois
  # GET /pois.json
  def index
    @filterrific = initialize_filterrific(
      Poi,
      params[:filterrific],
      select_options: {}
    )

    # Sin uso real
    # @pois = policy_scope(@filterrific.try(:find) || Poi)
    @pois = @filterrific.try(:find) || Poi

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
    # @poi.update(vistas: @poi.vistas + 1)
    @poi.update_columns(
      vistas: @poi.increment(:vistas, 1).vistas
    )

    if request.format.html?
      @og_image_url = first_image_to_share(@poi)
      @total_attachment_size = @poi.imagenes.map(&:byte_size).sum
    end

    return unless @poi.puntajes.any?

    @puntaje_prom = @poi.puntajes.map { |pu| pu[1] }.sum.to_f / @poi.puntajes.count
  end

  # GET /pois/search
  # GET /pois/search.json
  def search
    index
  end

  # GET /pois/new
  def new
    @poi = Poi.new(user: current_user)
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
    params[:poi][:titulo] = params[:poi][:titulo].strip
    @poi = Poi.new(poi_params)
    # @poi.geo_point = "POINT(#{poi_params['long']} #{poi_params['lat']})"
    @poi.user = current_user if @poi.user.nil?

    inferir_ciudad if request.format.json?

    respond_to do |format|
      format.html do
        if (params[:poi][:imagenes].nil? || save_images_html(params, @poi, :poi)) && @poi.valid? && @poi.save
          # expire_action :action => :index, cache_path: -> { request.fullpath }
          # expire_action :action => :search, cache_path: -> { request.fullpath }
          redirect_to new_poi_path, notice: "PoI satisfactoriamente creado."
        else
          render :new
        end
      end
      format.json do
        if (params[:imagenes].nil? || params[:imagenes].class == Array && save_images_json(params, @poi) && @poi.valid?) && @poi.save
          notificar_mencionados(@poi, "pois")
          notificar_created(@poi)
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
    params[:poi][:titulo] = params[:poi][:titulo].strip
    current_mencionados = get_mencionados(@poi)
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
          new_mencionados = get_mencionados(@poi)
          (new_mencionados - current_mencionados).each do |m|
            nueva_mencion(@poi, "pois", m)
          end
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

  def saved
    saved_obj(@poi)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_poi
    @poi = Poi.with_attached_imagenes.find(params[:id])
  end

  def fetch_items
    @pois = @pois
            .order(titulo: :asc)
            .limit(params.key?(:limit) ? params[:limit].to_i : 10)
            .offset(params.key?(:offset) ? params[:offset].to_i : 0)
    return if params[:limit] && request.format.json?

    @pois = @pois.page(params[:page])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def poi_params
    if request.format.json?
      params.require(:poi).permit(:titulo, :cuerpo, :whatsapp, :lat, :long, :direccion, :categoria_poi_id)
    else
      params.require(:poi).permit(:titulo, :cuerpo, :whatsapp, :lat, :long, :direccion, :categoria_poi_id, :habilitado, :user_id, :ciudad_id)
    end
  end
end
