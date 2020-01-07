class ContactoMailer < ApplicationMailer
  # Envia un mail a los admins por un Contacto de usuario
  def email_contacto
    to = params[:to] || "admins@arrancando.com.ar"
    subject = "Nuevo mensaje de contacto desde la app"
    @text = params[:text]
    @user = params[:user]
    mail(to: to, subject: subject)
  end
end
