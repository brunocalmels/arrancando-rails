class AddPopuladaToCiudad < ActiveRecord::Migration[6.0]
  def change
    add_column :ciudades, :populada, :boolean, default: false
  end
end
