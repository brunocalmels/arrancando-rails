class HomeController < ApplicationController
  # skip_before_action :authenticate_request

  def index
    @user = current_user
    respond_to do |format|
      format.json do
        render json: "Bienvenido"
      end
      format.html {}
    end
  end

  # GET /docs
  def docs
  end

  # POST /contacto
  def contacto
    respond_to do |format|
      format.json do
        Reporte.create(
          contenido: params.permit(:mensaje)["mensaje"],
          user: current_user
        )
        ContactoMailer.with(
          text: params["mensaje"],
          user: current_user
        ).email_contacto.deliver_later
        render json: "Mensaje enviado"
      end
      format.html {}
    end
  end
end
