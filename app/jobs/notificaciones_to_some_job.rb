class NotificacionesToSomeJob < ApplicationJob
  include NotificacionesHelper

  queue_as :default

  def perform(users, notif_atts)
    users.each do |user|
      notif = Notificacion.create(notif_atts.merge!(user: user))
      web_fcm(notif)
    end
  end
end
