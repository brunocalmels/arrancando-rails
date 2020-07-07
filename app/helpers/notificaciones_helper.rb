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
              },
              "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "url": url
              })
  end

  def nuevo_comentario_publicacion(comentario)
    if comentario.publicacion.user != current_user
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
  end

  def nuevo_comentario_receta(comentario)
    if comentario.receta.user != current_user
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
  end

  def nuevo_comentario_poi(comentario)
    if comentario.poi.user != current_user
      titulo = "Nuevo comentario"
      cuerpo = "@#{comentario.user.username} comentó tu punto de interés '#{comentario.poi.titulo}'"
      url = "/pois/#{comentario.poi.id}"
      user = comentario.poi.user
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
  end

  def nueva_puntuacion(obj, puntaje)
    if obj.user != current_user
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
  end

  def compartio_contenido(obj, tipo)
    if obj.user != current_user
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
  end

  def nuevo_like_comentario(comentario, tipo, obj_id)
    if comentario.user != current_user
      titulo = "A @#{current_user.username} le gustó tu comentario"
      cuerpo = "@#{current_user.username} indicó que le gustó tu comentario: #{comentario.mensaje[0, 10]}..."
      url = "/#{tipo}/#{obj_id}"
      user = comentario.user
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
  end

  def nuevo_seguimiento(seguimiento)
    if seguimiento.seguido != current_user
      titulo = "@#{current_user.username} comenzó a seguirte"
      cuerpo = "@#{current_user.username} ha comenzado a seguirte, seguilo/a vos también!"
      url = "/usuarios/#{current_user.username}"
      user = seguimiento.seguido
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
  end

  def nueva_mencion(obj, tipo, user, comentario)
    if user != current_user
      pretty_tipo = tipo == "publicaciones" ? "publicación" : tipo == "pois" ? "punto de interés" : "receta"
      articulo = tipo == "pois" ? 'el' : 'la'
      titulo = if comentario
                  "@#{current_user.username} te mencionó en un comentario"
              else
                "@#{current_user.username} te mencionó en su #{pretty_tipo}"
              end
      cuerpo =  if comentario
                  "@#{current_user.username} te mencionó en un comentario de #{articulo} #{pretty_tipo} #{obj.titulo}"
                else
                  "@#{current_user.username} te mencionó en su #{pretty_tipo} #{obj.titulo}"
                end
      url = "/#{tipo}/#{obj.id}"
      user = user
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
  end

  def web_fcm(notificacion)
    user = notificacion.user
    unless user.firebase_token.nil?
      set_fcm
      response = send_fcm(
        user.firebase_token,
        notificacion.titulo,
        notificacion.cuerpo,
        url: notificacion.url,
      )
    end
  end
end
