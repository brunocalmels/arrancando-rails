class CiudadesController < ApplicationController
  # before_action :set_ciudad, only: %i[show edit update destroy]
  before_action :set_ciudad, only: %i[show]

  # GET /ciudades
  # GET /ciudades.json
  def index
    @filterrific = initialize_filterrific(Ciudad, params[:filterrific], select_options: {})
    @ciudades = policy_scope(@filterrific.try(:find) || Ciudad)

    @ciudades = @ciudades.page(params[:page]) unless request.format.json?
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

  # # GET /ciudades/new
  # def new
  #   @ciudad = Ciudad.new
  # end

  # # GET /ciudades/1/edit
  # def edit
  # end

  # # POST /ciudades
  # # POST /ciudades.json
  # def create
  #   @ciudad = Ciudad.new(ciudad_params)

  #   respond_to do |format|
  #     if @ciudad.save
  #       format.html { redirect_to @ciudad, notice: 'Ciudad was successfully created.' }
  #       format.json { render :show, status: :created, location: @ciudad }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @ciudad.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /ciudades/1
  # # PATCH/PUT /ciudades/1.json
  # def update
  #   respond_to do |format|
  #     if @ciudad.update(ciudad_params)
  #       format.html { redirect_to @ciudad, notice: 'Ciudad was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @ciudad }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @ciudad.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /ciudades/1
  # # DELETE /ciudades/1.json
  # def destroy
  #   @ciudad.destroy
  #   respond_to do |format|
  #     format.html { redirect_to ciudades_url, notice: 'Ciudad was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  #   # Use callbacks to share common setup or constraints between actions.
  def set_ciudad
    @ciudad = Ciudad.find(params[:id])
  end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def ciudad_params
  #     params.fetch(:ciudad, {})
  #   end
end
