module UsersMigrationHelper
  def migrate_user(original_owner, new_owner)
    change_owner(original_owner.publicaciones, new_owner)
    change_owner(original_owner.recetas, new_owner)
    change_owner(original_owner.pois, new_owner)
    change_owner(original_owner.comentario_publicaciones, new_owner)
    change_owner(original_owner.comentario_recetas, new_owner)
    change_owner(original_owner.comentario_pois, new_owner)
    change_likes(Publicacion, original_owner, new_owner)
    change_likes(Receta, original_owner, new_owner)
    change_likes(Poi, original_owner, new_owner)
  end

  def change_owner(items, new_owner)
    items.each do |item|
      item.update(user_id: new_owner.id)
    end
  end

  def change_likes(items, original_owner, new_owner)
    items
      .where("puntajes -> '?' is not null", original_owner.id)
      .each do |item|
      punt = item.puntajes[original_owner.id.to_s]
      item.update(puntajes: item
                    .puntajes
                    .except(original_owner.id.to_s)
                    .merge(new_owner.id.to_s => punt))
    end
  end
end
