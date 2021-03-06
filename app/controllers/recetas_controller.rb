# rubocop: disable Metrics/ClassLength

class RecetasController < ApplicationController
  include ContentHelper
  include NotificacionesHelper
  before_action :set_receta, only: %i[update destroy puntuar saved]
  before_action :set_receta_with_attachments, only: %i[show edit]

  caches_action :index,
                expires_in: DEFAULT_INDEX_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath },
                if: -> { request.format.json? }

  caches_action :search,
                expires_in: DEFAULT_INDEX_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath },
                if: -> { request.format.json? }

  # GET /recetas
  # GET /recetas.json
  def index
    @filterrific = initialize_filterrific(Receta, params[:filterrific], select_options: {})
    @recetas = policy_scope(@filterrific.try(:find) || Receta)

    if request.format.json? && !params.include?("filterrific")
      filter_by_categoria_receta_id
      filter_by_term
      filter_habilitados
    end

    fetch_items

    render :index
  end

  # GET /recetas/1
  # GET /recetas/1.json
  def show
    @receta.update_columns(
      vistas: @receta.increment(:vistas, 1).vistas
    )

    unless request.format.json?
      @og_image_url = first_image_to_share(@receta)
      @total_attachment_size = @receta.imagenes.map(&:byte_size).sum
    end

    return unless @receta.puntajes.any?

    @puntaje_prom = @receta.puntajes.map { |pu| pu[1] }.sum.to_f / @receta.puntajes.count
  end

  # GET /recetas/search
  # GET /recetas/search.json
  def search
    index
  end

  # GET /recetas/new
  def new
    @receta = Receta.new(user: current_user)
  end

  # GET /recetas/1/edit
  def edit
    authorize @receta
  end

  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/AbcSize
  # POST /recetas
  # POST /recetas.json
  def create
    params[:receta][:titulo] = params[:receta][:titulo].strip
    @receta = Receta.new(receta_params)
    @receta.user = current_user if @receta.user.nil?
    @receta.subcategoria_receta_ids = params[:subcategoria_receta_ids]

    respond_to do |format|
      format.html do
        if (params[:receta][:imagenes].nil? || save_images_html(params, @receta, :receta)) && @receta.valid? && @receta.save
          parse_ingredientes
          notificar_created(@receta) if params[:receta][:notify_followers]
          redirect_to new_receta_path, notice: "Receta satisfactoriamente creada."
        else
          set_ciudades
          render :new
        end
      end
      format.json do
        if (params[:imagenes].nil? || params[:imagenes].class == Array && save_images_json(params, @receta)) && @receta.valid? && @receta.save
          parse_ingredientes
          notificar_mencionados(@receta, "recetas")
          notificar_created(@receta)
          render :show, status: :created, location: @receta
        else
          render json: @receta.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /recetas/1
  # PATCH/PUT /recetas/1.json
  def update
    authorize @receta
    params[:receta][:titulo] = params[:receta][:titulo].strip
    current_mencionados = get_mencionados(@receta)
    respond_to do |format|
      format.html do
        if @receta.update(receta_params) && (params[:receta][:imagenes].nil? && params["remove_imagenes"].nil? || update_images_html(params, @receta, :receta))
          parse_ingredientes
          redirect_to @receta, notice: "Receta satisfactoriamente actualizada."
        else
          render :edit
        end
      end
      format.json do
        if @receta.update(receta_params) && (params[:imagenes].nil? && params["remove_imagenes"].nil? || update_images_json(params, @receta))
          parse_ingredientes
          unless params[:subcategoria_receta_ids].nil?
            @receta.update subcategoria_receta_ids: params[:subcategoria_receta_ids]
          end
          new_mencionados = get_mencionados(@receta)
          (new_mencionados - current_mencionados).each do |m|
            nueva_mencion(@receta, "recetas", m)
          end
          render :show, status: :ok, location: @receta
        else
          render json: @receta.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/PerceivedComplexity

  # DELETE /recetas/1
  # DELETE /recetas/1.json
  def destroy
    authorize @receta
    @receta.destroy
    respond_to do |format|
      format.html { redirect_to recetas_url, notice: "Receta satisfactoriamente eliminada." }
      format.json { head :no_content }
    end
  end

  def puntuar
    puntuar_obj(@receta)
  end

  def saved
    saved_obj(@receta)
  end

  private

  # rubocop:disable Metrics/AbcSize
  def parse_ingredientes
    return if params[:ingredientes_items].nil?

    ingr_items = params[:ingredientes_items]
    ingr_items = ingr_items.values if request.format.html?

    ingr_items.each do |ing|
      next if Ingrediente.exists?(nombre: ing["ingrediente"])

      Ingrediente.create(nombre: ing["ingrediente"])
    end
    @receta.update ingredientes_items: ingr_items

    @receta.ingredientes_items.filter { |f| f["cantidad"] == "Cant. necesaria" }.each { |f| f["unidad"] = "" }
    @receta.ingredientes_items.filter! { |f| !f["ingrediente"].blank? }
    @receta.ingredientes_items.filter! { |f| !f["cantidad"].blank? }
    @receta.save
  end

  # rubocop:enable Metrics/AbcSize

  def filter_by_categoria_receta_id
    return unless params.key? :categoria_receta_id

    @recetas = @recetas
               .where(categoria_receta_id: params[:categoria_receta_id].to_i)
  end

  def filter_by_term
    return unless params.key? :term

    @recetas = @recetas
               .search(params[:term])
  end

  def filter_habilitados
    @recetas = @recetas.habilitados
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_receta
    @receta = Receta.find(params[:id])
  end

  def set_receta_with_attachments
    @receta = Receta
              .eager_load(comentarios: [:user])
              .with_attached_imagenes
              .find(params[:id])
  end

  def fetch_items
    @recetas = @recetas
               .eager_load(:user, :categoria_receta)
               .with_attached_imagenes
               .order(updated_at: :desc)
               .limit(params.key?(:limit) ? params[:limit].to_i : 10)
               .offset(params.key?(:offset) ? params[:offset].to_i : 0)
    return if params[:limit] && request.format.json?

    @recetas = @recetas.page(params[:page])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receta_params
    if request.format.json?
      params.require(:receta).permit(:titulo, :cuerpo, :introduccion, :instrucciones, :categoria_receta_id, :duracion, :complejidad, ingredientes_items: [])
    else
      params.require(:receta).permit(:titulo, :cuerpo, :introduccion, :instrucciones, :categoria_receta_id, :habilitado, :user_id, :duracion, :complejidad, :ingredientes, ingredientes_items: [])
    end
  end
end

# rubocop: enable Metrics/ClassLength
