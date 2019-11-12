class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    unless command.success?
      render(json: { error: command.errors }, status: :unauthorized) && return
    end

    @u = User.find_by_email(params[:email])
    if @u.activo
      respond_to do |format|
        format.json do
          render json: {
            auth_token: command.result,
            id: @u.id,
            nombre: @u.nombre,
            apellido: @u.apellido,
            email: @u.email,
            username: @u.username
            # avatar: @avatar,
            # preferencia: !@u.preferencia.nil? ? @u.preferencia.attributes.merge(keys: KEYS_PREFERENCIAS) : nil
          }
        end
        format.html do
          session[:auth_token] = command.result
          redirect_to root_url
        end
      end
    elsif @u.credentials["activation_token"]
      render json: { message: "Cuenta no activada" }, status: :locked
    else
      render json: { message: "No permitido" }, status: :unauthorized
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
