class NotificacionesToAllJob < ApplicationJob
  include NotificacionesHelper

  queue_as :default

  def perform(notif_atts)
    User.all.each do |user|
      notif = Notificacion.create(notif_atts.merge!(user: user))
      web_fcm(notif)
    end
  end
end
