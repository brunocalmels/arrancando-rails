class CreatePaises < ActiveRecord::Migration[6.0]
  def up
    create_table :paises do |t|
      t.string :nombre, null: false

      t.timestamps
    end

    Pais.create(nombre: "Argentina")
  end

  def down
    drop_table :paises
  end
end
