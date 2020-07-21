class NotificacionesToSomeJob < ApplicationJob
  include NotificacionesHelper

  queue_as :default

  def perform(users, notif_atts)
    notif = Notificacion.new(notif_atts)
    users.each do |user|
      print "****** Enviando notif. a #{user.username} *******"
      notif.user = user
      web_fcm(notif)
    end
  end
end
