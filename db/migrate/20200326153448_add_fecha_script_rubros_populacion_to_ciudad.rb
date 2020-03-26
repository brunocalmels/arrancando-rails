class AddFechaScriptRubrosPopulacionToCiudad < ActiveRecord::Migration[6.0]
  def change
    add_column :ciudades, :fecha_populacion, :datetime
    add_column :ciudades, :version_script_populacion, :string
    add_column :ciudades, :rubros, :string, array: true, default: []
  end
end
