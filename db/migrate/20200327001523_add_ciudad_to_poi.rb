class AddCiudadToPoi < ActiveRecord::Migration[6.0]
  def change
    add_reference :pois, :ciudad, foreign_key: true, null: false, default: Ciudad.where(nombre: "Neuquén").first.id
  end
end
