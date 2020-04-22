class SubcategoriaRecetasController < ApplicationController
  before_action :set_subcategoria_receta, only: %i[show edit update destroy]

  # GET /subcategoria_recetas
  # GET /subcategoria_recetas.json
  def index
    @filterrific = initialize_filterrific(SubcategoriaReceta.order(nombre: :asc), params[:filterrific], select_options: {})
    @subcategoria_recetas = @filterrific.try(:find) || SubcategoriaReceta.order(nombre: :asc)
    @subcategoria_recetas = @subcategoria_recetas.page(params[:page])
  end

  # # GET /subcategoria_recetas/1
  # # GET /subcategoria_recetas/1.json
  # def show
  # end

  # # GET /subcategoria_recetas/new
  # def new
  #   @subcategoria_receta = SubcategoriaReceta.new
  # end

  # GET /subcategoria_recetas/1/edit
  def edit
  end

  # # POST /subcategoria_recetas
  # # POST /subcategoria_recetas.json
  # def create
  #   @subcategoria_receta = SubcategoriaReceta.new(subcategoria_receta_params)

  #   respond_to do |format|
  #     if @subcategoria_receta.save
  #       format.html { redirect_to new_subcategoria_receta_path, notice: "Subcategoría Receta satisfactoriamente creada." }
  #       format.json { render :show, status: :created, location: @subcategoria_receta }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @subcategoria_receta.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /subcategoria_recetas/1
  # PATCH/PUT /subcategoria_recetas/1.json
  def update
    respond_to do |format|
      if @subcategoria_receta.update(subcategoria_receta_params)
        format.html { redirect_to subcategoria_recetas_path, notice: "Subcategoría Receta satisfactoriamente actualizada." }
        format.json { render :show, status: :ok, location: @subcategoria_receta }
      else
        format.html { render :edit }
        format.json { render json: @subcategoria_receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategoria_recetas/1
  # DELETE /subcategoria_recetas/1.json
  def destroy
    @subcategoria_receta.destroy
    respond_to do |format|
      format.html { redirect_to subcategoria_recetas_url, notice: "Subcategoría Receta satisfactoriamente eliminada." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subcategoria_receta
    @subcategoria_receta = SubcategoriaReceta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subcategoria_receta_params
    params.require(:subcategoria_receta).permit(:nombre)
  end
end
