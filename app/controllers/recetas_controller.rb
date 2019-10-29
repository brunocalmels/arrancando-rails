class RecetasController < ApplicationController
  before_action :set_receta, only: %i[show edit update destroy]

  # GET /recetas
  # GET /recetas.json
  def index
    @recetas = Receta.all
  end

  # GET /recetas/1
  # GET /recetas/1.json
  def show
  end

  # GET /recetas/search
  # GET /recetas/search.json
  def search
    @term = params[:term]
    @lim = params[:limit]
    @recetas = Receta
               .search(@term)
               .limit(@lim)
               .page(params[:page])
    respond_to do |format|
      format.json { render json: @recetas }
    end
  end

  # GET /recetas/new
  def new
    @receta = Receta.new
  end

  # GET /recetas/1/edit
  def edit
  end

  # POST /recetas
  # POST /recetas.json
  def create
    @receta = Receta.new(receta_params)

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
    @receta.destroy
    respond_to do |format|
      format.html { redirect_to recetas_url, notice: "Receta was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_receta
    @receta = Receta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receta_params
    params.require(:receta).permit(:titulo, :cuerpo, :puntaje, :categoria_receta_id)
  end
end
