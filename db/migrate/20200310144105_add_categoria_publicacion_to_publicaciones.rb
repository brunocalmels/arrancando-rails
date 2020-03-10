class AddCategoriaPublicacionToPublicaciones < ActiveRecord::Migration[6.0]
  def change
    add_reference :publicaciones, :categoria_publicacion, null: false, default: CategoriaPublicacion.comunidad.id, foreign_key: true
  end
end
