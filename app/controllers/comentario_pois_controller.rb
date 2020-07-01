class ComentarioPoisController < ApplicationController
  include NotificacionesHelper
  before_action :set_comentario_poi, only: %i[show edit update destroy]

  # GET /comentario_pois
  # GET /comentario_pois.json
  def index
    @comentario_pois = ComentarioPoi.page(params[:page])
  end

  # GET /comentario_pois/1
  # GET /comentario_pois/1.json
  def show
  end

  # GET /comentario_pois/new
  def new
    @comentario_poi = ComentarioPoi.new
  end

  # GET /comentario_pois/1/edit
  def edit
  end

  # POST /comentario_pois
  # POST /comentario_pois.json
  def create
    @comentario_poi = ComentarioPoi.new(comentario_poi_params)
    @comentario_poi.user = current_user

    respond_to do |format|
      if @comentario_poi.save
        nuevo_comentario_poi(@comentario_poi)
        format.html { redirect_to @comentario_poi, notice: 'Comentario poi was successfully created.' }
        format.json { render :show, status: :created, location: @comentario_poi }
      else
        format.html { render :new }
        format.json { render json: @comentario_poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comentario_pois/1
  # PATCH/PUT /comentario_pois/1.json
  def update
    authorize @comentario_poi, policy_class: ComentarioPolicy
    respond_to do |format|
      if @comentario_poi.update(comentario_poi_params)
        format.html { redirect_to @comentario_poi, notice: 'Comentario poi was successfully updated.' }
        format.json { render :show, status: :ok, location: @comentario_poi }
      else
        format.html { render :edit }
        format.json { render json: @comentario_poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comentario_pois/1
  # DELETE /comentario_pois/1.json
  def destroy
    authorize @comentario_poi, policy_class: ComentarioPolicy
    @comentario_poi.destroy
    respond_to do |format|
      format.html { redirect_to comentario_pois_url, notice: 'Comentario poi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comentario_poi
    @comentario_poi = ComentarioPoi.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comentario_poi_params
    params.require(:comentario_poi).permit(:poi_id, :mensaje)
  end
end
