# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/CyclomaticComplexity

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :assure_admin!, except: %i[create update login set_avatar google_client new_google_client apple_client facebook_client]
  skip_before_action :authenticate_request, only: %i[create login google_client new_google_client apple_client facebook_client]
  before_action :user_by_email, only: %i[google_client]
  before_action :user_by_email_new_google, only: %i[new_google_client]
  before_action :user_by_email_apple, only: %i[apple_client]
  before_action :user_by_email_fb, only: %i[facebook_client]

  # GET /users
  # GET /users.json
  def index
    @rol = params[:rol]
    @filterrific = initialize_filterrific(User,
                                          params[:filterrific],
                                          select_options: {
                                            sorted_by: User.options_for_sorted_by
                                          })
    @users = policy_scope(UserPolicy::Scope
      .new(current_user, @filterrific.try(:find) || User)
      .send("rol_#{@rol}"))
             .page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.rol = :normal
    @user.activo = true
    if @user.save
      @auth_token = JsonWebToken.encode(user_id: @user.id)
      rta = @user.attributes
      rta["auth_token"] = @auth_token
      render json: rta, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Usuario satisfactoriamente guardado." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "Usuario satisfactoriamente eliminado." }
      format.json { head :no_content }
    end
  end

  # GET /login
  def login
  end

  def google_client
    data = {
      auth_token: JsonWebToken.encode(user_id: @user.id),
      id: @user.id,
      nombre: @user.nombre,
      apellido: @user.apellido,
      email: @user.email,
      username: @user.username
    }

    data[:avatar] = if @user.avatar.attached?
                      rails_blob_path(@user.avatar)
                    else
                      "/images/unknown.png"
                    end
    redirect_to "https://arrancando.com.ar/google-signin/" + encode64(data.to_json) + "/"
  end

  def facebook_client
    data = {
      auth_token: JsonWebToken.encode(user_id: @user.id),
      id: @user.id,
      nombre: @user.nombre,
      apellido: @user.apellido,
      email: @user.email,
      username: @user.username
    }

    data[:avatar] = if @user.avatar.attached?
                      rails_blob_path(@user.avatar)
                    else
                      "/images/unknown.png"
                    end
    redirect_to "https://arrancando.com.ar/facebook-signin/" + encode64(data.to_json) + "/"
  end

  def apple_client
    data = {
      auth_token: JsonWebToken.encode(user_id: @user.id),
      id: @user.id,
      nombre: @user.nombre,
      apellido: @user.apellido,
      email: @user.email,
      username: @user.username
    }

    data[:avatar] = if @user.avatar.attached?
                      rails_blob_path(@user.avatar)
                    else
                      "/images/unknown.png"
                    end

    render json: data
  end

  def new_google_client
    data = {
      auth_token: JsonWebToken.encode(user_id: @user.id),
      id: @user.id,
      nombre: @user.nombre,
      apellido: @user.apellido,
      email: @user.email,
      username: @user.username
    }

    data[:avatar] = if @user.avatar.attached?
                      rails_blob_path(@user.avatar)
                    else
                      "/images/unknown.png"
                    end

    render json: data
  end

  # POST /users/avatar
  def set_avatar
    if params[:avatar].class == ActionDispatch::Http::UploadedFile
      current_user.set_avatar_file(params[:avatar])
    else
      current_user.set_avatar(params[:avatar])
    end
    render json: { avatar: rails_blob_path(current_user.avatar) }, status: :ok
  end

  private

  def random_string
    (0...8).map { rand(65..90).chr }.join.downcase
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    if request.format.json?
      params.require(:user).permit(:nombre, :apellido, :email, :username, :password, :telefono, :app_version, :platform, :ciudad_id)
    else # HTML
      params.require(:user).permit(:nombre, :apellido, :email, :username, :rol, :telefono, :activo, :avatar, :ciudad_id, :rankeable)
    end
  end

  def encode64(data)
    Base64.encode64(data).gsub("+", "-").gsub("/", "_")
  end

  def oauth_client
    @client = OAuth2::Client.new(
      ENV["GOOGLE_APP_ID"],
      ENV["GOOGLE_APP_SEC"],
      site: "https://www.googleapis.com/",
      token_url: "/oauth2/v4/token",
      raise_errors: false,
      additional_parameters: {
        access_type: "offline",
        include_granted_scopes: true
      }
    )
  end

  def oauth_client_fb
    @client = OAuth2::Client.new(
      ENV["FACEBOOK_APP_ID"],
      ENV["FACEBOOK_APP_SECRET"],
      site: "https://graph.facebook.com/v5.0",
      token_url: "/oauth/access_token",
      raise_errors: false
    )
  end

  def oauth_access_token
    @access_token = @client.auth_code.get_token(
      params[:code],
      redirect_uri: "https://arrancando.herokuapp.com/google-login"
    )

    unless @access_token.params["id_token"]
      render json: @access_token.params.to_json, status: :unprocessable_entity
    end

    return unless @access_token.params["id_token"]
  end

  def oauth_access_token_fb
    @access_token = @client.auth_code.get_token(
      params[:code],
      redirect_uri: "https://arrancando.herokuapp.com/facebook-login"
    )

    unless @access_token.params["token_type"]
      render json: @access_token.params.to_json, status: :unprocessable_entity
    end

    return unless @access_token.params["token_type"]
  end

  def user_metadata
    response = @access_token.get("/oauth2/v2/userinfo?fields=*")

    unless response
      render json: "Response no encontrada", status: :unprocessable_entity && return
    end
    @metadata = JSON.parse(response.body)
    unless @metadata && (@metadata["email"] || @metadata["id"])
      render json: "Respuesta de formato incorrecto", status: :unprocessable_entity && return
    end

    fix_user_metadata
  end

  def user_metadata_fb
    response = @access_token.get("/v5.0/me?fields=email")

    unless response
      render json: "Response no encontrada", status: :unprocessable_entity && return
    end
    @metadata = JSON.parse(response.body)
    unless @metadata && (@metadata["email"] || @metadata["id"])
      render json: "Respuesta de formato incorrecto", status: :unprocessable_entity && return
    end

    fix_user_metadata_fb
  end

  def fix_user_metadata
    @email = @metadata["email"] || "#{@metadata['id']}@not-gmail.com"
    @nombre = if @metadata["email"]
                @metadata["email"].split("@")[0].gsub(".", "_")
              else
                @metadata["id"]
              end
    @username = @nombre.gsub('.', '_').gsub(' ', '')
    @password = "#{encode64(@nombre)}-#{random_string}"
  end

  def fix_user_metadata_apple
    @metadata = params['credentials']
    @email = @metadata["email"] || "#{@metadata['user']}@not-apple.com"
    @nombre = if !@metadata["name"].nil?
                @metadata["name"]
              elsif !@metadata["email"].nil?
                @metadata["email"].split("@")[0].gsub(".", "_")
              else
                "usuario-#{@metadata['user'].split('.').first}"
              end
    @username = @nombre.gsub('.', '_').gsub(' ', '')
    @password = "#{encode64(@nombre)}-#{random_string}"
  end

  def fix_user_metadata_new_google
    @metadata = params['credentials']
    @email = @metadata["email"] || "#{@metadata['id']}@not-gmail.com"
    @nombre = if !@metadata["name"].nil?
                @metadata["name"]
              elsif !@metadata["email"].nil?
                @metadata["email"].split("@")[0].gsub(".", "_")
              else
                "usuario-#{@metadata['id'].split('.').first}"
              end
    @username = @nombre.gsub('.', '_').gsub(' ', '')
    @password = "#{encode64(@nombre)}-#{random_string}"
  end

  def fix_user_metadata_fb
    @email = @metadata["email"] || "#{@metadata['id']}@not-facebook.com"
    @nombre = if !@metadata["email"].nil?
                @metadata["email"].split("@")[0].gsub(".", "_")
              else
                @metadata["id"]
              end
    @username = @nombre.gsub('.', '_').gsub(' ', '')
    @password = "#{encode64(@nombre)}-#{random_string}"
  end

  def user_by_email
    oauth_client
    oauth_access_token
    user_metadata

    build_user

    # user.grab_image(@metadata["picture"])
  rescue StandardError => e
    puts e
    redirect_to "https://arrancando.com.ar"
  end

  def user_by_email_apple
    fix_user_metadata_apple

    build_user
  rescue StandardError => e
    puts e
    render json: nil, status: :unprocessable_entity
  end

  def user_by_email_new_google
    fix_user_metadata_new_google

    build_user
  rescue StandardError => e
    puts e
    render json: nil, status: :unprocessable_entity
  end

  def user_by_email_fb
    oauth_client_fb
    oauth_access_token_fb
    user_metadata_fb

    build_user

    # user.grab_image(@metadata["picture"])
  rescue StandardError => e
    puts e
    redirect_to "https://arrancando.com.ar"
  end

  def build_user
    @user = User.find_by_email(@email) || User.create!(
      nombre: @nombre,
      username: @username,
      email: @email,
      password: @password
    )
  end
end

# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/CyclomaticComplexity
