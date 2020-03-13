class CiudadesController < ApplicationController
  before_action :set_ciudad, only: %i[show edit update]

  # GET /ciudades
  # GET /ciudades.json
  def index
    @filterrific = initialize_filterrific(Ciudad.order(id: :asc), params[:filterrific], select_options: {})
    @ciudades = policy_scope(@filterrific.try(:find) || Ciudad.order(id: :asc))

    if request.format.json?
      render json: @ciudades
    else
      @ciudades = @ciudades.page(params[:page])
      alert_new_ciudades
    end
  end

  def search
    return unless params.key?(:term) && params[:term].length >= 3

    @ciudades = Ciudad.search(params[:term])
    render "ciudades/index_con_provincia.json"
  end

  # # GET /ciudades/1
  # # GET /ciudades/1.json
  def show
    render json: @ciudad
  end

  # GET /ciudades/new
  def new
    @ciudad = Ciudad.new
  end

  # GET /ciudades/1/edit
  def edit
  end

  # POST /ciudades
  # POST /ciudades.json
  def create
    @ciudad = Ciudad.new(ciudad_params)

    respond_to do |format|
      if @ciudad.save
        format.html { redirect_to @ciudad, notice: "Ciudad satisfactoriamente creada." }
        format.json { render :show, status: :created, location: @ciudad }
      else
        format.html { render :new }
        format.json { render json: @ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ciudades/1
  # PATCH/PUT /ciudades/1.json
  def update
    respond_to do |format|
      if @ciudad.update(ciudad_params)
        format.html { redirect_to ciudades_path, notice: "Ciudad satisfactoriamente actualizada." }
        format.json { render :show, status: :ok, location: @ciudad }
      else
        format.html { render :edit }
        format.json { render json: @ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /ciudades/1
  # # DELETE /ciudades/1.json
  # def destroy
  #   @ciudad.destroy
  #   respond_to do |format|
  #     format.html { redirect_to ciudades_url, notice: 'Ciudad satisfactoriamente eliminada.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Busca ciudades con usuarios activos y sin popular
  def alert_new_ciudades
    @ciudades_alert = Ciudad.joins(:users)
                            .distinct
                            .where(populada: false)
                            .pluck(:nombre, :id)
  end

  #   # Use callbacks to share common setup or constraints between actions.
  def set_ciudad
    @ciudad = Ciudad.find(params[:id])
  end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  def ciudad_params
    params.require(:ciudad).permit(:nombre, :provincia_id)
  end
end
