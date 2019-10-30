class AddDireccionToPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :pois, :direccion, :string
  end
end
