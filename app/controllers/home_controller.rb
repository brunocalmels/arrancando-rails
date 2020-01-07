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

  def contacto
    respond_to do |format|
      format.json do
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
