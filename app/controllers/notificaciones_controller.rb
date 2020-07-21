class NotificacionesController < ApplicationController
  include NotificacionesHelper

  # before_action :set_notificacion, only: %i[show edit update destroy]

  # GET /notificaciones.json
  def index
    @notificaciones = Notificacion.where(user_id: current_user).order(created_at: :desc).page(1)
  end

  def unread
    @notificaciones = Notificacion.where(user_id: current_user, leido: false).order(created_at: :desc)
    render json: @notificaciones
  end

  # # GET /notificaciones/1
  # # GET /notificaciones/1.json
  # def show
  # end

  # GET /notificaciones/new
  def new
    @notificacion = Notificacion.new

    @filtered_user_ids = params['user_ids']
  end

  # # GET /notificaciones/1/edit
  # def edit
  # end

  # POST /notificaciones
  # POST /notificaciones.json
  def create
    @notificacion = Notificacion.new(notificacion_params)
    if params[:all_users]
      send_to_all
      return
    elsif (@users = User.find(params[:filtered_user_ids].split(' ')))
      send_to_some
      return
    end
    web_fcm(@notificacion)
    respond_to do |format|
      if @notificacion.save
        format.html { redirect_to new_notificacion_path, notice: "Notificación creada satisfactoriamente." }
        format.json { render :show, status: :created, location: @notificacion }
      else
        format.html { render :new }
        format.json { render json: @notificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_to_some
    @notificacion.user = @users.first
    unless @notificacion.valid?
      redirect_to(
        users_path,
        alert: @notificacion.errors
      ) && return
    end
    NotificacionesToSomeJob.perform_later(@users, @notificacion.attributes)
    redirect_to(
      users_path,
      notice: "Se enviarán las notificaciones en breve."
    )
  end

  def send_to_all
    unless @notificacion.valid?
      redirect_to(
        new_notificacion_path,
        alert: @notificacion.errors
      ) && return
    end
    NotificacionesToAllJob.perform_later(@notificacion.attributes)
    redirect_to(
      new_notificacion_path,
      notice: "Se enviarán las notificaciones en breve."
    )
  end

  # # PATCH/PUT /notificaciones/1
  # # PATCH/PUT /notificaciones/1.json
  # def update
  #   respond_to do |format|
  #     if @notificacion.update(notificacion_params)
  #       format.html { redirect_to @notificacion, notice: "Notificación guardada satisfactoriamente." }
  #       format.json { render :show, status: :ok, location: @notificacion }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @notificacion.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /notificaciones/1
  # # DELETE /notificaciones/1.json
  # def destroy
  #   @notificacion.destroy
  #   respond_to do |format|
  #     format.html { redirect_to notificaciones_url, notice: "Notificación eliminada satisfactoriamente." }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_notificacion
  #   @notificacion = Notificacion.find(params[:id])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def notificacion_params
    params.require(:notificacion).permit(:titulo, :cuerpo, :url, :leido, :user_id)
  end
end
