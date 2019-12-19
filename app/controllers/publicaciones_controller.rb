class PublicacionesController < ApplicationController
  include ContentHelper
  before_action :set_publicacion, only: %i[show edit update destroy puntuar]

  # GET /publicaciones
  # GET /publicaciones.json
  def index
    @filterrific = initialize_filterrific(Publicacion, params[:filterrific], select_options: {})
    @publicaciones = policy_scope(@filterrific.try(:find) || Publicacion)

    if request.format.json?
      filter_by_ciudad_id
      filter_by_term
    end

    @publicaciones = @publicaciones
                     .order(created_at: :desc)
                     .limit(params.key?(:limit) ? params[:limit].to_i : 10).page params[:page]
    render :index
  end

  # GET /publicaciones/1
  # GET /publicaciones/1.json
  def show
  end

  # GET /publicaciones/search
  # GET /publicaciones/search.json
  def search
    index
  end

  # GET /publicaciones/new
  def new
    @publicacion = Publicacion.new
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
    @publicacion = Publicacion.new(publicacion_params)
    @publicacion.user = current_user

    respond_to do |format|
      format.html do
        if (params[:publicacion][:imagenes].nil? || save_images_html(params, @publicacion, :publicacion)) && @publicacion.valid? && @publicacion.save
          redirect_to @publicacion, notice: "Publicación satisfactoriamente creada."
        else
          render :new
        end
      end
      format.json do
        if (params[:imagenes].nil? || params[:imagenes].class == Array && save_images_json(params, @publicacion)) && @publicacion.valid? && @publicacion.save
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
    respond_to do |format|
      format.html do
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

  # Use callbacks to share common setup or constraints between actions.
  def set_publicacion
    @publicacion = Publicacion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def publicacion_params
    params.require(:publicacion).permit(:titulo, :cuerpo, :puntajes, :ciudad_id)
  end
end
