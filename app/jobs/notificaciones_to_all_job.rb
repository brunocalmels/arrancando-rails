class NotificacionesToAllJob < ApplicationJob
  include NotificacionesHelper

  queue_as :default

  def perform(notif_atts)
    notif = Notificacion.new(notif_atts)
    User.all.each do |user|
      notif.user = user
      web_fcm(notif)
    end
  end
end
