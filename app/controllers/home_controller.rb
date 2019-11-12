class HomeController < ApplicationController
  skip_before_action :authenticate_request

  def index
    @user = current_user
    respond_to do |format|
      format.json do
        render json: "Bienvenido"
      end
      format.html {}
    end
  end
end
