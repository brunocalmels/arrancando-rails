class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # rubocop:disable Metrics/AbcSize
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    unless command.success?
      render(json: { error: command.errors }, status: :unauthorized) && return
    end

    @u = User.find_by_email(params[:email])
    @avatar = rails_blob_path(@u.avatar) if @u.avatar.attached?

    if @u.activo
      respond_to do |format|
        format.json do
          render json: {
            auth_token: command.result,
            id: @u.id,
            nombre: @u.nombre,
            apellido: @u.apellido,
            email: @u.email,
            username: @u.username,
            instagram: @u.url_instagram,
            avatar: @avatar
          }
        end
        format.html do
          session[:auth_token] = command.result
          redirect_to root_url, notice: "Te logueaste correctamente."
        end
      end
    elsif @u.credentials["activation_token"]
      render json: { message: "Cuenta no activada" }, status: :locked
    else
      render json: { message: "No permitido" }, status: :unauthorized
    end
  end

  def deauthenticate
    respond_to do |format|
      format.html do
        session[:auth_token] = nil
        redirect_to root_url, notice: "Te deslogueaste correctamente."
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
end
