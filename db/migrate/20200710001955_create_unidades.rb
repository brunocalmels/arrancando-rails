class CreateUnidades < ActiveRecord::Migration[6.0]
  def change
    create_table :unidades do |t|
      t.string :nombre, null: false, default: ""

      t.timestamps
    end
    UNIDADES.each do |uni|
      Unidad.create(nombre: uni)
    end
  end
end
