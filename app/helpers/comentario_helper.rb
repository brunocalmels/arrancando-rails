# rubocop: disable Metrics/AbcSize

module ComentarioHelper
  include NotificacionesHelper

  def ref_id(comentario)
    if comentario.class.name == "ComentarioPublicacion"
      comentario.publicacion_id
    elsif comentario.class.name == "ComentarioReceta"
      comentario.receta_id
    else
      comentario.poi_id
    end
  end

  def ref_type(comentario)
    if comentario.class.name == "ComentarioPublicacion"
      "publicaciones"
    elsif comentario.class.name == "ComentarioReceta"
      "recetas"
    else
      "pois"
    end
  end

  def puntuar_comentario(comentario)
    if comentario.puntajes[current_user.id.to_s].nil?
      comentario.puntajes[current_user.id.to_s] = 1
    else
      comentario.puntajes.delete(current_user.id.to_s)
    end
    if comentario.save
      if comentario.puntajes[current_user.id.to_s] == 1
        nuevo_like_comentario(
          comentario,
          ref_type(comentario),
          ref_id(comentario)
        )
      end
      render json: nil, status: :ok
    else
      render json: "Invalid data", status: :unprocessable_entity
    end
  end

  def comment_my_puntajes(comentario)
    comentario.puntajes.map do |k, v|
      { usuario: { id: k.to_i }, puntaje: v }
    end
  end
end

# rubocop: enable Metrics/AbcSize
