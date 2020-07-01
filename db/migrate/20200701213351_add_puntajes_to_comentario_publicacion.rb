class AddPuntajesToComentarioPublicacion < ActiveRecord::Migration[6.0]
  def change
    add_column :comentario_publicaciones, :puntajes, :jsonb, default: {}
  end
end
