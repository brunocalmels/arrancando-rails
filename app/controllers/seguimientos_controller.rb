class SeguimientosController < ApplicationController
  include NotificacionesHelper
  before_action :set_seguimiento, only: %i[show edit update destroy]

  # GET /seguimientos
  # GET /seguimientos.json
  def index
    @seguimientos = Seguimiento.all
  end

  def seguidos
    user = User.find(params[:uid])
    users = User.where(id: user.seguimientos.pluck(:seguido_id))
    if users.count > 0
      users = users.map do |u|
        avatar = u.avatar.attached? ? rails_blob_path(u.avatar) : "/images/unknown.png"
        o = u.attributes
        o['avatar'] = avatar
        o
      end
    end
    render json: users.to_json, status: :ok
  end

  def seguidores
    user = User.find(params[:uid])
    users = User.where(id: user.seguidores.pluck(:seguidor_id))
    if users.count > 0
      users = users.map do |u|
        avatar = u.avatar.attached? ? rails_blob_path(u.avatar) : "/images/unknown.png"
        o = u.attributes
        o['avatar'] = avatar
        o
      end
    end
    render json: users.to_json, status: :ok
  end

  # GET /seguimientos/1
  # GET /seguimientos/1.json
  def show
  end

  # GET /seguimientos/new
  def new
    @seguimiento = Seguimiento.new
  end

  # GET /seguimientos/1/edit
  def edit
  end

  # POST /seguimientos
  # POST /seguimientos.json
  def create
    @seguimiento = Seguimiento.new(seguimiento_params)
    @seguimiento.seguidor = current_user

    respond_to do |format|
      if @seguimiento.save
        nuevo_seguimiento(@seguimiento)
        format.html { redirect_to @seguimiento, notice: 'Seguimiento was successfully created.' }
        format.json { render :show, status: :created, location: @seguimiento }
      else
        format.html { render :new }
        format.json { render json: @seguimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seguimientos/1
  # PATCH/PUT /seguimientos/1.json
  def update
    respond_to do |format|
      if @seguimiento.update(seguimiento_params)
        format.html { redirect_to @seguimiento, notice: 'Seguimiento was successfully updated.' }
        format.json { render :show, status: :ok, location: @seguimiento }
      else
        format.html { render :edit }
        format.json { render json: @seguimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seguimientos/1
  # DELETE /seguimientos/1.json
  def destroy
    @seguimiento.destroy
    respond_to do |format|
      format.html { redirect_to seguimientos_url, notice: 'Seguimiento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seguimiento
    @seguimiento = Seguimiento.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seguimiento_params
    params.require(:seguimiento).permit(:seguido_id)
  end
end
