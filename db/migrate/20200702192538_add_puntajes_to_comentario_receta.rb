class AddPuntajesToComentarioReceta < ActiveRecord::Migration[6.0]
  def change
    add_column :comentario_recetas, :puntajes, :jsonb, default: {}
  end
end
