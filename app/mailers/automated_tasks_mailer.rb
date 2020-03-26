class AutomatedTasksMailer < ApplicationMailer
  # Envía un mail por ciudad populada automáticamente
  def email_ciudad_populada
    to = params[:to] || "admins@arrancando.com.ar"
    subject = "Ciudad populada - #{params[:ciudad]}"
    @text = params[:text]
    mail(to: to, subject: subject)
  end
end
