module UsersHelper
  # rubocop: disable Naming/AccessorMethodName
  # TODO: Arreglar esto
  def set_avatar(avatar)
    tempfile = Tempfile.new("fileupload")
    tempfile.binmode
    tempfile.write(Base64.decode64(avatar))
    tempfile.rewind

    mime_type = Mime::Type
                .lookup_by_extension(File.extname("filename.jpg")[1..-1])
                .to_s
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: tempfile,
      filename: "filename.jpg",
      type: mime_type
    )
    self.avatar.attach(uploaded_file)
  end

  # rubocop: enable Naming/AccessorMethodName

  def grab_image(url)
    downloaded_image = URI.parse(url).open
    avatar.attach(io: downloaded_image, filename: "downloaded.jpg")
  end

  def weigh_for_5_star_items(items)
    cuenta_out = 0
    items.all.each do |item|
      cuenta_in = 0
      item.puntajes.each do |_k, v|
        cuenta_in += 1 if v == 5
      end
      cuenta_out += 1 if cuenta_in >= 5
      cuenta_out += 1 if cuenta_in >= 10
    end
    cuenta_out
  end

  # def pubs_more_eq_than_x_comments(pubs, howmany)
  #   pubs
  #     .select("publicaciones.*,
  #       COUNT(comentario_publicaciones.id) as comment_count")
  #     .joins("LEFT OUTER JOIN comentario_publicaciones
  #       ON (comentario_publicaciones.publicacion_id = publicaciones.id)")
  #     .group("publicaciones.id")
  #     .select { |pub| pub.comment_count >= howmany }
  #     .count
  # end

  # def recs_more_eq_than_x_comments(recs, howmany)
  #   recs
  #     .select("recetas.*,
  #       COUNT(comentario_recetas.id) as comment_count")
  #     .joins("LEFT OUTER JOIN comentario_recetas
  #       ON (comentario_recetas.receta_id = recetas.id)")
  #     .group("recetas.id")
  #     .select { |rec| rec.comment_count >= howmany }
  #     .count
  # end

  def weigh_number(number)
    case number
    when 0..4
      number
    when 5..9
      number * 2
    else
      number * 3
    end
  end

  def publicaciones_puntuadas
    Publicacion.where("puntajes -> '?' is not null", id)
  end

  def borrar_puntajes_publicaciones
    publicaciones_puntuadas.each do |pub|
      pub.update puntajes: pub.puntajes.except(id.to_s)
    end
  end

  def recetas_puntuadas
    Receta.where("puntajes -> '?' is not null", id)
  end

  def borrar_puntajes_recetas
    recetas_puntuadas.each do |rec|
      rec.update puntajes: rec.puntajes.except(id.to_s)
    end
  end

  def pois_puntuados
    Poi.where("puntajes -> '?' is not null", id)
  end

  def borrar_puntajes_pois
    pois_puntuados.each do |poi|
      poi.update puntajes: poi.puntajes.except(id.to_s)
    end
  end
end
