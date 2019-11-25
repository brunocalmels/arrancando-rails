class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :assure_admin!, except: %i[create login udpate set_avatar]
  skip_before_action :authenticate_request, only: %i[create login]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
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
        format.html { redirect_to @user, notice: "User was successfully updated." }
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
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /login
  def login
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

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.permit(:nombre, :apellido, :email, :username, :password, :telefono)
  end
end
