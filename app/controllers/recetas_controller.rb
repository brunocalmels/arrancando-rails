class RecetasController < ApplicationController
  include ContentHelper
  before_action :set_receta, only: %i[show edit update destroy puntuar]

  # GET /recetas
  # GET /recetas.json
  def index
    @recetas = Receta
    filter_by_categoria_receta_id
    filter_by_term
    @recetas = @recetas
               .limit(params.key?(:limit) ? params[:limit].to_i : 10)
    render :index
  end

  # GET /recetas/1
  # GET /recetas/1.json
  def show
  end

  # GET /recetas/search
  # GET /recetas/search.json
  def search
    index
  end

  # GET /recetas/new
  def new
    @receta = Receta.new
  end

  # GET /recetas/1/edit
  def edit
    authorize @receta
  end

  # POST /recetas
  # POST /recetas.json
  def create
    @receta = Receta.new(receta_params)
    @receta.user = current_user
    save_images

    respond_to do |format|
      if @receta.save
        format.html { redirect_to @receta, notice: "Receta was successfully created." }
        format.json { render :show, status: :created, location: @receta }
      else
        format.html { render :new }
        format.json { render json: @receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recetas/1
  # PATCH/PUT /recetas/1.json
  def update
    authorize @receta
    update_images
    respond_to do |format|
      if @receta.update(receta_params)
        format.html { redirect_to @receta, notice: "Receta was successfully updated." }
        format.json { render :show, status: :ok, location: @receta }
      else
        format.html { render :edit }
        format.json { render json: @receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recetas/1
  # DELETE /recetas/1.json
  def destroy
    authorize @receta
    @receta.destroy
    respond_to do |format|
      format.html { redirect_to recetas_url, notice: "Receta was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def puntuar
    puntuar_obj(@receta)
  end

  private

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

  # Use callbacks to share common setup or constraints between actions.
  def set_receta
    @receta = Receta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receta_params
    params.require(:receta).permit(:titulo, :cuerpo, :puntajes, :categoria_receta_id)
  end

  def save_images
    params[:imagenes].each do |img|
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode
      tempfile.write(Base64.decode64(img))
      tempfile.rewind
      mime_type = Mime::Type.lookup_by_extension(File.extname("filename.jpg")[1..-1]).to_s
      uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: "filename.jpg", type: mime_type)
      @receta.imagenes.attach(uploaded_file)
    end
  end

  def update_images
    remove_imagenes(@receta) if params['remove_imagenes']
    save_images if params[:imagenes].class == Array
  end
end
