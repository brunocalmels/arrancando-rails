class AddHabilitadoToPublicacion < ActiveRecord::Migration[6.0]
  def change
    add_column :publicaciones, :habilitado, :boolean, default: true
  end
end
