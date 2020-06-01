class ComentarioRecetasController < ApplicationController
  include NotificacionesHelper
  before_action :set_comentario_receta, only: %i[show edit update destroy]

  # GET /comentario_recetas
  # GET /comentario_recetas.json
  def index
    @comentario_recetas = ComentarioReceta.page(params[:page])
  end

  # GET /comentario_recetas/1
  # GET /comentario_recetas/1.json
  def show
  end

  # GET /comentario_recetas/new
  def new
    @comentario_receta = ComentarioReceta.new
  end

  # GET /comentario_recetas/1/edit
  def edit
  end

  # POST /comentario_recetas
  # POST /comentario_recetas.json
  def create
    @comentario_receta = ComentarioReceta.new(comentario_receta_params)
    @comentario_receta.user = current_user

    respond_to do |format|
      if @comentario_receta.save
        nuevo_comentario_receta(@comentario_receta)
        format.html { redirect_to @comentario_receta, notice: 'Comentario receta fue satisfactoriamente creada.' }
        format.json { render :show, status: :created, location: @comentario_receta }
      else
        format.html { render :new }
        format.json { render json: @comentario_receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comentario_recetas/1
  # PATCH/PUT /comentario_recetas/1.json
  def update
    authorize @comentario_receta, policy_class: ComentarioPolicy
    respond_to do |format|
      if @comentario_receta.update(comentario_receta_params)
        format.html { redirect_to @comentario_receta, notice: 'Comentario receta fue satisfactoriamente actualizada.' }
        format.json { render :show, status: :ok, location: @comentario_receta }
      else
        format.html { render :edit }
        format.json { render json: @comentario_receta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comentario_recetas/1
  # DELETE /comentario_recetas/1.json
  def destroy
    authorize @comentario_receta, policy_class: ComentarioPolicy
    @comentario_receta.destroy
    respond_to do |format|
      format.html { redirect_to comentario_recetas_url, notice: 'Comentario receta fue satisfactoriamente eliminada.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comentario_receta
    @comentario_receta = ComentarioReceta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comentario_receta_params
    params.require(:comentario_receta).permit(:receta_id, :mensaje)
  end
end
