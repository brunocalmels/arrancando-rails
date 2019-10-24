class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # rubocop:disable Metrics/AbcSize
  def authenticate
    # command = AuthenticateUser.call(params[:control_field], params[:password])
    command = AuthenticateUser.call(params[:email], params[:password])

    unless command.success?
      render(json: { error: command.errors }, status: :unauthorized) && return
    end

    # @u = find_user_by_control_field(params[:control_field])
    @u = User.find_by_email(params[:email])
    if @u.activo
      # @avatar = if @u.avatar.attached?
      #             rails_blob_path(@u.avatar)
      #           else
      #             "/images/missing.jpg"
      #           end
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
    elsif @u.credentials["activation_token"]
      render json: { message: "Cuenta no activada" }, status: :locked
    else
      render json: { message: "No permitido" }, status: :unauthorized
    end
  end

  # rubocop:enable Metrics/AbcSize
end
