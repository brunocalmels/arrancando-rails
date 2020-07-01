module ComentarioHelper
  def puntuar_comentario(comentario)
    unless params["puntaje"]
      render(json: "Invalid data", status: :unprocessable_entity) && return
    end
    comentario.puntajes[current_user.id] = params["puntaje"].to_i
    if comentario.save
      render json: nil, status: :ok
    else
      render json: "Invalid data", status: :unprocessable_entity
    end
  end
end
