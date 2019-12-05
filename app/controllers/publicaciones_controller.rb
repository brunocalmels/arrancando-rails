# rubocop:disable Metrics/ClassLength
class PublicacionesController < ApplicationController
  include ContentHelper
  before_action :set_publicacion, only: %i[show edit update destroy puntuar]

  # GET /publicaciones
  # GET /publicaciones.json
  def index
    @publicaciones = Publicacion
    filter_by_ciudad_id
    filter_by_term
    @publicaciones = @publicaciones
                     .order(created_at: :desc)
                     .limit(params.key?(:limit) ? params[:limit].to_i : 10)
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

  # POST /publicaciones
  # POST /publicaciones.json
  def create
    @publicacion = Publicacion.new(publicacion_params)
    @publicacion.user = current_user

    respond_to do |format|
      if @publicacion.save
        format.html do
          save_images_html
          redirect_to @publicacion, notice: "Publicación satisfactoriamente creada."
        end
        format.json do
          save_images_json if params[:imagenes].class == Array
          render :show, status: :created, location: @publicacion
        end
      else
        format.html { render :new }
        format.json { render json: @publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  # PATCH/PUT /publicaciones/1
  # PATCH/PUT /publicaciones/1.json
  def update
    authorize @publicacion
    respond_to do |format|
      if @publicacion.update(publicacion_params)
        format.html do
          unless params[:publicacion][:imagenes].nil? && params["remove_imagenes"].nil?
            update_images_html
          end
          redirect_to @publicacion, notice: "Publicación satisfactoriamente actualizada."
        end
        format.json do
          unless params[:imagenes].nil? && params["remove_imagenes"].nil?
            update_images_json
          end
          render :show, status: :ok, location: @publicacion
        end
      else
        format.html { render :edit }
        format.json { render json: @publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:enable Metrics/AbcSize

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

  def save_images_json
    params[:imagenes].each do |img|
      @publicacion.imagenes.attach(
        build_base64_img(img)
      )
    end
  end

  def save_images_html
    imagenes = params[:publicacion][:imagenes]
    imagenes.each do |img|
      @publicacion.imagenes.attach img
    end
  end

  def update_images_json
    remove_imagenes(@publicacion) if params["remove_imagenes"]
    save_images_json
  end

  def update_images_html
    remove_imagenes(@publicacion) if params["remove_imagenes"]
    save_images_html unless params[:publicacion][:imagenes].nil?
  end
end

# rubocop:enable Metrics/ClassLength
