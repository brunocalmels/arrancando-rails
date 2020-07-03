class AddPuntajesToComentarioPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :comentario_pois, :puntajes, :jsonb, default: {}
  end
end
