class NotificationSendSingleWorker
  include Sidekiq::Worker
  include NotificacionesHelper

  sidekiq_options retry: false

  def perform(user_id, titulo, cuerpo, url)
    create_notification_and_send(user_id, titulo, cuerpo, url)
  end
end
