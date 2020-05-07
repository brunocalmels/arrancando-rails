class ComentarioPublicacionesController < ApplicationController
  before_action :set_comentario_publicacion, only: %i[show edit update destroy]

  # GET /comentario_publicaciones
  # GET /comentario_publicaciones.json
  def index
    @comentario_publicaciones = ComentarioPublicacion.all
  end

  # GET /comentario_publicaciones/1
  # GET /comentario_publicaciones/1.json
  def show
  end

  # GET /comentario_publicaciones/new
  def new
    @comentario_publicacion = ComentarioPublicacion.new
  end

  # GET /comentario_publicaciones/1/edit
  def edit
  end

  # POST /comentario_publicaciones
  # POST /comentario_publicaciones.json
  def create
    @comentario_publicacion = ComentarioPublicacion.new(comentario_publicacion_params)
    @comentario_publicacion.user = current_user

    respond_to do |format|
      if @comentario_publicacion.save
        format.html { redirect_to @comentario_publicacion, notice: 'Comentario publicacion fue satisfactoriamente creada.' }
        format.json { render :show, status: :created, location: @comentario_publicacion }
      else
        format.html { render :new }
        format.json { render json: @comentario_publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comentario_publicaciones/1
  # PATCH/PUT /comentario_publicaciones/1.json
  def update
    authorize @comentario_publicacion, policy_class: ComentarioPolicy
    respond_to do |format|
      if @comentario_publicacion.update(comentario_publicacion_params)
        format.html { redirect_to @comentario_publicacion, notice: 'Comentario publicacion fue satisfactoriamente actualizada.' }
        format.json { render :show, status: :ok, location: @comentario_publicacion }
      else
        format.html { render :edit }
        format.json { render json: @comentario_publicacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comentario_publicaciones/1
  # DELETE /comentario_publicaciones/1.json
  def destroy
    authorize @comentario_publicacion, policy_class: ComentarioPolicy
    @comentario_publicacion.destroy
    respond_to do |format|
      format.html { redirect_to comentario_publicaciones_url, notice: 'Comentario publicacion fue satisfactoriamente eliminada.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comentario_publicacion
    @comentario_publicacion = ComentarioPublicacion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comentario_publicacion_params
    params.require(:comentario_publicacion).permit(:publicacion_id, :mensaje)
  end
end
