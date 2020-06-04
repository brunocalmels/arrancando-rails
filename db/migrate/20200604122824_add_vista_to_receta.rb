class AddVistaToReceta < ActiveRecord::Migration[6.0]
  def change
    add_column :recetas, :vistas, :bigint, default: 0
  end
end
