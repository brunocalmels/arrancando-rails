class AddVistaToPublicacion < ActiveRecord::Migration[6.0]
  def change
    add_column :publicaciones, :vistas, :bigint, default: 0
  end
end
