class AddHabilitadoToPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :pois, :habilitado, :boolean, default: true
  end
end
