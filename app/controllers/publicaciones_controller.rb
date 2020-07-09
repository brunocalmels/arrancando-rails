# rubocop: disable Metrics/ClassLength
class PublicacionesController < ApplicationController
  include ContentHelper
  include NotificacionesHelper
  before_action :set_publicacion, only: %i[show edit update destroy puntuar]

  # GET /publicaciones
  # GET /publicaciones.json
  def index
    @filterrific = initialize_filterrific(Publicacion, params[:filterrific], select_options: {})
    @publicaciones = policy_scope(@filterrific.try(:find) || Publicacion)

    if request.format.json? && !params.include?("filterrific")
      filter_by_categoria_publicacion_id
      filter_by_ciudad_id
      filter_by_term
      filter_habilitados
    end

    fetch_items

    render :index
  end

  # GET /publicaciones/1
  # GET /publicaciones/1.json
  def show
    # @publicacion.update(vistas: @publicacion.vistas + 1)
    @publicacion.update_columns(
      vistas: @publicacion.increment(:vistas, 1).vistas
    )

    @og_image_url = first_image_to_share(@publicacion)
    @total_attachment_size = @publicacion.imagenes.map(&:byte_size).sum

    return unless @publicacion.puntajes.any?

    @puntaje_prom = @publicacion.puntajes.map { |pu| pu[1] }.sum.to_f / @publicacion.puntajes.count
  end

  # GET /publicaciones/search
  # GET /publicaciones/search.json
  def search
    index
  end

  # GET /publicaciones/new
  def new
    @publicacion = Publicacion.new(user: current_user)
  end

  # GET /publicaciones/1/edit
  def edit
    authorize @publicacion
  end

  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity
  # rubocop: disable Metrics/AbcSize

  # POST /publicaciones
  # POST /publicaciones.json
  def create
    params[:publicacion][:titulo] = params[:publicacion][:titulo].strip
    @publicacion = Publicacion.new(publicacion_params)
    @publicacion.categoria_publicacion = CategoriaPublicacion.comunidad
    @publicacion.user = current_user if @publicacion.user.nil?

    respond_to do |format|
      format.html do
        @publicacion.categoria_publicacion_id = params[:publicacion][:categoria_publicacion_id]
        if (params[:publicacion][:imagenes].nil? || save_images_html(params, @publicacion, :publicacion)) && @publicacion.valid? && @publicacion.save
          redirect_to new_publicacion_path, notice: "Publicación satisfactoriamente creada."
        else
          render :new
        end
      end
      format.json do
        if (params[:imagenes].nil? || params[:imagenes].class == Array && save_images_json(params, @publicacion)) && @publicacion.valid? && @publicacion.save
          notificar_mencionados(@publicacion, "publicaciones")
          render :show, status: :created, location: @publicacion
        else
          render json: @publicacion.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /publicaciones/1
  # PATCH/PUT /publicaciones/1.json
  def update
    authorize @publicacion
    params[:publicacion][:titulo] = params[:publicacion][:titulo].strip
    respond_to do |format|
      format.html do
        @publicacion.categoria_publicacion_id = params[:publicacion][:categoria_publicacion_id]
        if @publicacion.update(publicacion_params) && (params[:publicacion][:imagenes].nil? && params["remove_imagenes"].nil? || update_images_html(params, @publicacion, :publicacion))
          redirect_to @publicacion, notice: "Publicación satisfactoriamente actualizada."
        else
          render :edit
        end
      end
      format.json do
        if @publicacion.update(publicacion_params) && (params[:imagenes].nil? && params["remove_imagenes"].nil? || update_images_json(params, @publicacion))
          render :show, status: :ok, location: @publicacion
        else
          render json: @publicacion.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/PerceivedComplexity

  # DELETE /publicaciones/1
  # DELETE /publicaciones/1.json
  def destroy
    authorize @publicacion
    @publicacion.destroy
    respond_to do |format|
      format.html { redirect_to publicaciones_url, notice: "Publicación satisfactoriamente eliminada." }
      format.json { head :no_content }
    end
  end

  def puntuar
    puntuar_obj(@publicacion)
  end

  private

  def filter_by_categoria_publicacion_id
    return unless params.key? :categoria_publicacion_id

    @publicaciones = @publicaciones
                     .where(categoria_publicacion_id: params[:categoria_publicacion_id].to_i)
  end

  def filter_by_ciudad_id
    return unless params.key? :ciudad_id

    @publicaciones = @publicaciones
                     .where(ciudad_id: params[:ciudad_id].to_i)
  end

  def filter_by_term
    return unless params.key? :term

    @publicaciones = @publicaciones
                     .search(params[:term])
  end

  def filter_habilitados
    @publicaciones = @publicaciones.habilitados
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_publicacion
    @publicacion = Publicacion.find(params[:id])
  end

  def fetch_items
    @publicaciones = @publicaciones
                     .order(updated_at: :desc)
                     .limit(params.key?(:limit) ? params[:limit].to_i : 10)
                     .offset(params.key?(:offset) ? params[:offset].to_i : 0)
    return if params[:limit] && request.format.json?

    @publicaciones = @publicaciones.page(params[:page])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def publicacion_params
    if request.format.json?
      params.require(:publicacion).permit(:titulo, :cuerpo, :puntajes, :ciudad_id)
    else
      params.require(:publicacion).permit(:titulo, :cuerpo, :puntajes, :ciudad_id, :habilitado, :user_id)
    end
  end
end

# rubocop: enable Metrics/ClassLength
