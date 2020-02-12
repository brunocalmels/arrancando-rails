class ReportesController < ApplicationController
  def index
    @reportes = policy_scope(Reporte.all)
  end

  def show
    @reporte = authorize Reporte.find(params[:id])
  end
end
