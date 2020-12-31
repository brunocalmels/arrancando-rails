class CategoriaRecetasController < ApplicationController
  before_action :set_categoria_receta, only: %i[edit update destroy]
  before_action :allow_only_html, except: [:index]

  caches_action :index,
                expires_in: LONG_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath },
                if: -> { request.format.json? }

  # GET /categoria_recetas
  # GET /categoria_recetas.json
  def index
    @categoria_recetas = if request.format.json?
                           CategoriaReceta.joins(:recetas).distinct.order(nombre: :asc).all
                         else
                           CategoriaReceta.order(nombre: :asc).all
                         end
  end

  # GET /categoria_recetas/new
  def new
    @categoria_receta = CategoriaReceta.new
  end

  # GET /categoria_recetas/1/edit
  def edit
  end

  # POST /categoria_recetas
  # POST /categoria_recetas.json
  def create
    @categoria_receta = CategoriaReceta.new(categoria_receta_params)

    respond_to do |format|
      if @categoria_receta.save
        format.html { redirect_to categoria_recetas_path, notice: "Categoría receta satisfactoriamente creada." }
        # format.json { render :show, status: :created, location: @categoria_receta }
      else
        format.html { render :new }
        # format.json { render json: @categoria_receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categoria_recetas/1
  # PATCH/PUT /categoria_recetas/1.json
  def update
    respond_to do |format|
      if @categoria_receta.update(categoria_receta_params)
        format.html { redirect_to categoria_recetas_path, notice: "Categoría receta satisfactoriamente guardada." }
        # format.json { render :show, status: :ok, location: @categoria_receta }
      else
        format.html { render :edit }
        # format.json { render json: @categoria_receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categoria_recetas/1
  # DELETE /categoria_recetas/1.json
  def destroy
    @categoria_receta.destroy
    respond_to do |format|
      format.html { redirect_to categoria_recetas_url, notice: "Categoría receta satisfactoriamente eliminada." }
      # format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_categoria_receta
    @categoria_receta = CategoriaReceta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def categoria_receta_params
    params.require(:categoria_receta).permit(:nombre)
  end
end
