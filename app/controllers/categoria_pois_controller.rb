class CategoriaPoisController < ApplicationController
  before_action :set_categoria_poi, only: %i[edit update destroy]
  before_action :allow_only_html, except: [:index]

  # GET /categoria_pois
  # GET /categoria_pois.json
  def index
    @categoria_pois = CategoriaPoi.all
  end

  # # GET /categoria_pois/1
  # # GET /categoria_pois/1.json
  # def show
  # end

  # GET /categoria_pois/new
  def new
    @categoria_poi = CategoriaPoi.new
  end

  # GET /categoria_pois/1/edit
  def edit
  end

  # POST /categoria_pois
  # POST /categoria_pois.json
  def create
    @categoria_poi = CategoriaPoi.new(categoria_poi_params)

    respond_to do |format|
      if @categoria_poi.save
        format.html { redirect_to categoria_pois_path, notice: "Categoría PoI satisfactoriamente creada." }
        # format.json { render :show, status: :created, location: @categoria_poi }
      else
        format.html { render :new }
        # format.json { render json: @categoria_poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categoria_pois/1
  # PATCH/PUT /categoria_pois/1.json
  def update
    respond_to do |format|
      if @categoria_poi.update(categoria_poi_params)
        format.html { redirect_to categoria_pois_path, notice: "Categoría PoI satisfactoriamente guardada." }
        # format.json { render :show, status: :ok, location: @categoria_poi }
      else
        format.html { render :edit }
        # format.json { render json: @categoria_poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categoria_pois/1
  # DELETE /categoria_pois/1.json
  def destroy
    @categoria_poi.destroy
    respond_to do |format|
      format.html { redirect_to categoria_pois_url, notice: "Categoría PoI satisfactoriamente eliminada." }
      # format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_categoria_poi
    @categoria_poi = CategoriaPoi.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def categoria_poi_params
    params.require(:categoria_poi).permit(:nombre)
  end
end
