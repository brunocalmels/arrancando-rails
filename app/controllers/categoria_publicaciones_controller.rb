class CategoriaPublicacionesController < ApplicationController
  before_action :set_categoria_publicacion, only: %i[edit update destroy]
  before_action :allow_only_html, except: [:index]

  # GET /categoria_publicaciones
  # GET /categoria_publicaciones.json
  def index
    @categoria_publicaciones = CategoriaPublicacion.all
  end

  # GET /categoria_publicaciones/new
  def new
    @categoria_publicacion = CategoriaPublicacion.new
  end

  # GET /categoria_publicaciones/1/edit
  def edit
  end

  # POST /categoria_publicaciones
  # POST /categoria_publicaciones.json
  def create
    @categoria_publicacion = CategoriaPublicacion.new(categoria_publicacion_params)

    respond_to do |format|
      if @categoria_publicacion.save
        format.html { redirect_to categoria_publicaciones_path, notice: "Categoría publicación satisfactoriamente creada." }
        # format.json { render :show, status: :created, location: @categoria_publicacion }
      else
        format.html { render :new }
        # format.json { render json: @categoria_publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categoria_publicaciones/1
  # PATCH/PUT /categoria_publicaciones/1.json
  def update
    respond_to do |format|
      if @categoria_publicacion.update(categoria_publicacion_params)
        format.html { redirect_to categoria_publicaciones_path, notice: "Categoría publicación satisfactoriamente guardada." }
        # format.json { render :show, status: :ok, location: @categoria_publicacion }
      else
        format.html { render :edit }
        # format.json { render json: @categoria_publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categoria_publicaciones/1
  # DELETE /categoria_publicaciones/1.json
  def destroy
    @categoria_publicacion.destroy
    respond_to do |format|
      format.html { redirect_to categoria_publicaciones_url, notice: "Categoría publicación satisfactoriamente eliminada." }
      # format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_categoria_publicacion
    @categoria_publicacion = CategoriaPublicacion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def categoria_publicacion_params
    params.require(:categoria_publicacion).permit(:nombre)
  end
end
