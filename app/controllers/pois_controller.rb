class PoisController < ApplicationController
  before_action :set_poi, only: %i[show edit update destroy]

  # GET /pois
  # GET /pois.json
  def index
    @lim = params[:limit]
    @pois = Poi.all.limit @lim
    @pois = @pois.page params[:page]
  end

  # GET /pois/1
  # GET /pois/1.json
  def show
  end

  # GET /pois/search
  # GET /pois/search.json
  def search
    @term = params[:term]
    @lim = params[:limit]
    @pois = Poi
            .search(@term)
            .limit(@lim)
            .page(params[:page])
    respond_to do |format|
      format.json { render json: @pois }
    end
  end

  # GET /pois/new
  def new
    @poi = Poi.new
  end

  # GET /pois/1/edit
  def edit
  end

  # POST /pois
  # POST /pois.json
  def create
    @poi = Poi.new(poi_params)
    @poi.geo_point = "POINT(#{poi_params['long']} #{poi_params['lat']})"
    save_images

    respond_to do |format|
      if @poi.save
        format.html { redirect_to @poi, notice: "Poi was successfully created." }
        format.json { render :show, status: :created, location: @poi }
      else
        format.html { render :new }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pois/1
  # PATCH/PUT /pois/1.json
  def update
    respond_to do |format|
      if @poi.update(poi_params)
        format.html { redirect_to @poi, notice: "Poi was successfully updated." }
        format.json { render :show, status: :ok, location: @poi }
      else
        format.html { render :edit }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pois/1
  # DELETE /pois/1.json
  def destroy
    @poi.destroy
    respond_to do |format|
      format.html { redirect_to pois_url, notice: "Poi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_poi
    @poi = Poi.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def poi_params
    params.require(:poi).permit(:titulo, :cuerpo, :lat, :long, :puntaje, :direccion, :categoria_poi_id)
  end

  def save_images
    params[:imagenes].each do |img|
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode
      tempfile.write(Base64.decode64(img))
      tempfile.rewind
      mime_type = Mime::Type.lookup_by_extension(File.extname("filename.jpg")[1..-1]).to_s
      uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: "filename.jpg", type: mime_type)
      @poi.imagenes.attach(uploaded_file)
    end
  end
end
