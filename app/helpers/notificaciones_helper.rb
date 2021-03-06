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
                "url": url,
              })
  end

  def create_notification_and_send(user_id, titulo, cuerpo, url)
    user = User.find(user_id)
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

  def nuevo_comentario_publicacion(comentario)
    if comentario.publicacion.user != current_user
      titulo = "Nuevo comentario"
      cuerpo = "@#{comentario.user.username} comentó tu publicación '#{comentario.publicacion.titulo}'"
      url = "/publicaciones/#{comentario.publicacion.id}"
      user = comentario.publicacion.user
      NotificationSendSingleWorker.perform_async(
        user.id, titulo, cuerpo, url
      )
    end
  end

  def nuevo_comentario_receta(comentario)
    if comentario.receta.user != current_user
      titulo = "Nuevo comentario"
      cuerpo = "@#{comentario.user.username} comentó tu receta '#{comentario.receta.titulo}'"
      url = "/recetas/#{comentario.receta.id}"
      user = comentario.receta.user
      NotificationSendSingleWorker.perform_async(
        user.id, titulo, cuerpo, url
      )
    end
  end

  def nuevo_comentario_poi(comentario)
    if comentario.poi.user != current_user
      titulo = "Nuevo comentario"
      cuerpo = "@#{comentario.user.username} comentó tu tienda '#{comentario.poi.titulo}'"
      url = "/pois/#{comentario.poi.id}"
      user = comentario.poi.user
      NotificationSendSingleWorker.perform_async(
        user.id, titulo, cuerpo, url
      )
    end
  end

  def nueva_puntuacion(obj, puntaje)
    return if obj.user == current_user
    tipo = obj.class.name.downcase
    pretty_tipo = tipo == "publicacion" ? "publicación" : tipo == "poi" ? "tienda" : "recetas"
    tipo = tipo == "publicacion" ? "publicaciones" : tipo + "s"
    titulo = "@#{current_user.username} puntuó tu #{pretty_tipo}"
    cuerpo = "Tu #{pretty_tipo} #{obj.titulo} obtuvo #{puntaje} #{puntaje > 1 ? "puntos" : "punto"}"
    url = "/#{tipo}/#{obj.id}"
    user = obj.user
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def compartio_contenido(obj, tipo)
    return if obj.user == current_user
    pretty_tipo = tipo == "publicaciones" ? "publicación" : tipo == "pois" ? "tienda" : "recetas"
    titulo = "@#{current_user.username} compartió tu #{pretty_tipo}"
    cuerpo = "@#{current_user.username} compartió tu #{pretty_tipo} #{obj.titulo}"
    url = "/#{tipo}/#{obj.id}"
    user = obj.user
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def nuevo_like_comentario(comentario, tipo, obj_id)
    return if comentario.user == current_user
    titulo = "A @#{current_user.username} le gustó tu comentario"
    cuerpo = "@#{current_user.username} indicó que le gustó tu comentario: #{comentario.mensaje[0, 10]}..."
    url = "/#{tipo}/#{obj_id}"
    user = comentario.user
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def nuevo_seguimiento(seguimiento)
    return if seguimiento.seguido == current_user
    titulo = "@#{current_user.username} comenzó a seguirte"
    cuerpo = "@#{current_user.username} ha comenzado a seguirte, seguilo/a vos también!"
    url = "/usuarios/#{current_user.username}"
    user = seguimiento.seguido
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def notificar_created(item)
    notificar_seguidores(item)
  end

  def notificar_seguidores(item)
    creador = item.user
    tipo = item.class.to_s
    pretty_tipo = tipo == "Publicacion" ? "publicación" : tipo == "Poi" ? "tienda" : "receta"
    titulo = "@#{creador.username}, a quien seguís, creó una nueva #{pretty_tipo}"
    cuerpo = item.titulo
    url = "/#{tipo.pluralize.downcase}/#{item.id}"
    seguidores_ids = creador.seguidores.pluck :seguidor_id
    NotificationSendMultipleWorker.perform_async(
      seguidores_ids, titulo, cuerpo, url
    )
  end

  def nueva_mencion(obj, tipo, user, comentario: false)
    return if user == current_user

    pretty_tipo = tipo == "publicaciones" ? "publicación" : tipo == "pois" ? "tienda" : "recetas"
    articulo = tipo == "pois" ? "un" : "una"
    titulo = if comentario
               "@#{current_user.username} te mencionó en un comentario"
             else
               "@#{current_user.username} te mencionó en su #{pretty_tipo}"
             end
    cuerpo = if comentario
               "@#{current_user.username} te mencionó en un comentario de #{articulo} #{pretty_tipo}"
             else
               "@#{current_user.username} te mencionó en su #{pretty_tipo} #{obj.titulo}"
             end
    id = if comentario
           obj.ref_id
         else
           obj.id
         end
    url = "/#{tipo}/#{id}"
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def nueva_mencion_en_mensaje(current_user, mensaje, user, grupo)
    return if user == current_user

    titulo = "@#{current_user.username} te mencionó en un grupo"
    cuerpo = "@#{current_user.username} te mencionó en el grupo de chat #{grupo.nombre}"
    id = grupo.id
    url = "/grupo_chats/#{id}"
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def guardo_contenido(obj)
    return if obj.user == current_user
    tipo = obj.class.name.downcase
    pretty_tipo = tipo == "publicacion" ? "publicación" : tipo == "poi" ? "tienda" : "recetas"
    titulo = "@#{current_user.username} guardó tu #{pretty_tipo}"
    cuerpo = "@#{current_user.username} guardó tu #{pretty_tipo} #{obj.titulo}"
    tipo = tipo == "publicacion" ? "publicaciones" : tipo + "s"
    url = "/#{tipo}/#{obj.id}"
    user = obj.user
    NotificationSendSingleWorker.perform_async(
      user.id, titulo, cuerpo, url
    )
  end

  def web_fcm(notificacion)
    user = notificacion.user
    return if user.firebase_token.nil?
    logger.info "Enviando notificación a #{user.username}"
    set_fcm
    response = send_fcm(
      user.firebase_token,
      notificacion.titulo,
      notificacion.cuerpo,
      url: notificacion.url,
    )
  end
end
