class NotificationSendMultipleWorker
  include Sidekiq::Worker
  include NotificacionesHelper

  sidekiq_options retry: false

  def perform(user_ids, titulo, cuerpo, url)
    user_ids.each do |user_id|
      create_notification_and_send(user_id, titulo, cuerpo, url)
    end
  end
end
