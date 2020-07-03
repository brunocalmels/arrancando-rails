module ComentarioHelper
  def puntuar_comentario(comentario)
    if comentario.puntajes[current_user.id.to_s].nil?
      comentario.puntajes[current_user.id.to_s] = 1
    else
      comentario.puntajes.delete(current_user.id.to_s)
    end
    if comentario.save
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
