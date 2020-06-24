require "fcm"

module NotificacionesHelper
  def set_fcm
    @fcm ||= FCM.new(FIREBASE_FCM_KEY)
  end

  def send_fcm(token, title, body, url: "")
    @fcm.send(token,
              "notification": {
                "title": title,
                "body": body,
                "url": url,
              },
              "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
              })
  end

  def nuevo_comentario_publicacion(comentario)
    titulo = "Nuevo comentario"
    cuerpo = "@#{comentario.user.username} comentó tu publicación '#{comentario.publicacion.titulo}'"
    url = "/publicaciones/#{comentario.publicacion.id}"
    user = comentario.publicacion.user
    Notificacion.create(
      titulo: titulo,
      cuerpo: cuerpo,
      url: url,
      user: user,
    )
    unless user.firebase_token.nil?
      set_fcm
      response = send_fcm(
        user.firebase_token,
        titulo,
        cuerpo,
        url: url,
      )
    end
  end

  def nuevo_comentario_receta(comentario)
    titulo = "Nuevo comentario"
    cuerpo = "@#{comentario.user.username} comentó tu receta '#{comentario.receta.titulo}'"
    url = "/recetas/#{comentario.receta.id}"
    user = comentario.receta.user
    Notificacion.create(
      titulo: titulo,
      cuerpo: cuerpo,
      url: url,
      user: user,
    )
    unless user.firebase_token.nil?
      set_fcm
      response = send_fcm(
        user.firebase_token,
        titulo,
        cuerpo,
        url: url,
      )
    end
  end

  def nueva_puntuacion(obj, puntaje)
    tipo = obj.class.name.downcase
    pretty_tipo = tipo == "publicacion" ? "publicación" : tipo == "poi" ? "punto de interés" : "receta"
    tipo = tipo == "publicacion" ? "publicaciones" : tipo + "s"
    titulo = "Alguien puntuó tu #{pretty_tipo}"
    cuerpo = "Tu #{pretty_tipo} #{obj.titulo} obtuvo #{puntaje} puntos"
    url = "/#{tipo}/#{obj.id}"
    user = obj.user
    Notificacion.create(
      titulo: titulo,
      cuerpo: cuerpo,
      url: url,
      user: user,
    )
    unless user.firebase_token.nil?
      set_fcm
      response = send_fcm(
        user.firebase_token,
        titulo,
        cuerpo,
        url: url,
      )
    end
  end

  def compartio_contenido(obj, tipo)
    pretty_tipo = tipo == "publicaciones" ? "publicación" : tipo == "pois" ? "punto de interés" : "receta"
    titulo = "@#{current_user.username} compartió tu #{pretty_tipo}"
    cuerpo = "@#{current_user.username} compartió tu #{pretty_tipo} #{obj.titulo}"
    url = "/#{tipo}/#{obj.id}"
    user = obj.user
    Notificacion.create(
      titulo: titulo,
      cuerpo: cuerpo,
      url: url,
      user: user,
    )
    unless user.firebase_token.nil?
      set_fcm
      response = send_fcm(
        user.firebase_token,
        titulo,
        cuerpo,
        url: url,
      )
    end
  end

  def web_fcm(notificacion)
    user = notificacion.user
    unless user.firebase_token.nil?
      set_fcm
      response = send_fcm(
        user.firebase_token,
        titulo: notificacion.titulo,
        cuerpo: notificacion.cuerpo,
        url: notificacion.url,
      )
    end
  end
end
