class RecetasController < ApplicationController
  include ContentHelper
  before_action :set_receta, only: %i[show edit update destroy puntuar]

  # GET /recetas
  # GET /recetas.json
  def index
    @filterrific = initialize_filterrific(Receta, params[:filterrific], select_options: {})
    @recetas = policy_scope(@filterrific.try(:find) || Receta)

    if request.format.json?
      filter_by_categoria_receta_id
      filter_by_term
      filter_habilitados
    end

    fetch_items

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

  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/AbcSize
  # POST /recetas
  # POST /recetas.json
  def create
    @receta = Receta.new(receta_params)
    @receta.user = current_user

    respond_to do |format|
      format.html do
        if (params[:receta][:imagenes].nil? || save_images_html(params, @receta, :receta)) && @receta.valid? && @receta.save
          redirect_to new_receta_path, notice: "Receta satisfactoriamente creada."
        else
          render :new
        end
      end
      format.json do
        if (params[:imagenes].nil? || params[:imagenes].class == Array && save_images_json(params, @receta)) && @receta.valid? && @receta.save
          render :show, status: :created, location: @receta
        else
          render json: @receta.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /recetas/1
  # PATCH/PUT /recetas/1.json
  def update
    authorize @receta
    respond_to do |format|
      format.html do
        if @receta.update(receta_params) && (params[:receta][:imagenes].nil? && params["remove_imagenes"].nil? || update_images_html(params, @receta, :receta))
          redirect_to @receta, notice: "Receta satisfactoriamente actualizada."
        else
          render :edit
        end
      end
      format.json do
        if @receta.update(receta_params) && (params[:imagenes].nil? && params["remove_imagenes"].nil? || update_images_json(params, @receta))
          render :show, status: :ok, location: @receta
        else
          render json: @receta.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/PerceivedComplexity

  # DELETE /recetas/1
  # DELETE /recetas/1.json
  def destroy
    authorize @receta
    @receta.destroy
    respond_to do |format|
      format.html { redirect_to recetas_url, notice: "Receta satisfactoriamente eliminada." }
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

  def filter_habilitados
    @recetas = @recetas.habilitados
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_receta
    @receta = Receta.find(params[:id])
  end

  def fetch_items
    @recetas = @recetas
               .order(created_at: :desc)
               .limit(params.key?(:limit) ? params[:limit].to_i : 10)
    return if params[:limit] && request.format.json?

    @recetas = @recetas.page(params[:page])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receta_params
    params.require(:receta).permit(:titulo, :cuerpo, :introduccion, :ingredientes, :instrucciones, :categoria_receta_id, :habilitado)
  end
end
