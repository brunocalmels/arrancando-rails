class CreateCiudades < ActiveRecord::Migration[6.0]
  def change
    create_table :ciudades do |t|
      t.string :nombre, null: false
      t.references :provincia, null: false, foreign_key: true

      t.timestamps
    end
  end
end
