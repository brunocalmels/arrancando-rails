class PublicacionesController < ApplicationController
  before_action :set_publicacion, only: %i[show edit update destroy]

  # GET /publicaciones
  # GET /publicaciones.json
  def index
    @lim = params[:limit]
    @publicaciones = Publicacion.all.limit @lim
    @publicaciones = @publicaciones.page params[:page]
  end

  # GET /publicaciones/1
  # GET /publicaciones/1.json
  def show
  end

  # GET /publicaciones/search
  # GET /publicaciones/search.json
  def search
    @term = params[:term]
    @lim = params[:limit]
    @publicaciones = Publicacion
                     .search(@term)
                     .limit(@lim)
                     .page(params[:page])
    respond_to do |format|
      format.json { render json: @publicaciones }
    end
  end

  # GET /publicaciones/new
  def new
    @publicacion = Publicacion.new
  end

  # GET /publicaciones/1/edit
  def edit
  end

  # POST /publicaciones
  # POST /publicaciones.json
  def create
    @publicacion = Publicacion.new(publicacion_params)
    save_images if params[:imagenes].class == Array

    respond_to do |format|
      if @publicacion.save
        format.html { redirect_to @publicacion, notice: "Publicacion was successfully created." }
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
    respond_to do |format|
      if @publicacion.update(publicacion_params)
        format.html { redirect_to @publicacion, notice: "Publicacion was successfully updated." }
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
    @publicacion.destroy
    respond_to do |format|
      format.html { redirect_to publicaciones_url, notice: "Publicacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publicacion
    @publicacion = Publicacion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def publicacion_params
    params.require(:publicacion).permit(:titulo, :cuerpo, :puntajes, :ciudad_id)
  end

  def save_images
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
end
