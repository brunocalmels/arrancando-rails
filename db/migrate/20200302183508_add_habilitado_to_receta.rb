class AddHabilitadoToReceta < ActiveRecord::Migration[6.0]
  def change
    add_column :recetas, :habilitado, :boolean, default: true
  end
end
