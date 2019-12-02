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
    save_images if params[:imagenes].class == Array

    respond_to do |format|
      if @publicacion.save
        format.html { redirect_to @publicacion, notice: "Publicación satisfactoriamente creada." }
        format.json { render :show, status: :created, location: @publicacion }
      else
        format.html { render :new }
        format.json { render json: @publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publicaciones/1
  # PATCH/PUT /publicaciones/1.json
  def update
    authorize @publicacion
    update_images
    respond_to do |format|
      if @publicacion.update(publicacion_params)
        format.html { redirect_to @publicacion, notice: "Publicación satisfactoriamente actualizada." }
        format.json { render :show, status: :ok, location: @publicacion }
      else
        format.html { render :edit }
        format.json { render json: @publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def save_images
    return if params[:imagenes].nil?

    params[:imagenes].each do |img|
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode
      tempfile.write(Base64.decode64(img))
      tempfile.rewind
      mime_type = Mime::Type.lookup_by_extension(File.extname("filename.jpg")[1..-1]).to_s
      uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: "filename.jpg", type: mime_type)
      @publicacion.imagenes.attach(uploaded_file)
    end
  end

  def update_images
    remove_imagenes(@publicacion) if params["remove_imagenes"]
    save_images if params[:imagenes].class == Array
  end
end
