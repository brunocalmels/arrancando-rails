class UnidadesController < ApplicationController
  # GET /unidades_ingredientes
  # GET /unidades_ingredientes.json
  # GET /unidades
  # GET /unidades.json
  def index
    respond_to do |format|
      format.json do
        render json: Unidad.all.pluck(:nombre)
      end
      format.html do
        @unidades = Unidad.all
      end
    end
  end

  # GET /unidads/new
  def new
    @unidad = Unidad.new
  end

  # POST /unidades
  # POST /unidades.json
  def create
    @unidad = Unidad.new(unidad_params)

    respond_to do |format|
      if @unidad.save
        format.html { redirect_to new_unidad_path, notice: "Unidad satisfactoriamente creado." }
        format.json { render :show, status: :created, location: @unidad }
      else
        format.html { render :new }
        format.json { render json: @unidad.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def unidad_params
    params.require(:unidad).permit(:nombre)
  end
end
