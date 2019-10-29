class CreateCategoriaPois < ActiveRecord::Migration[6.0]
  def change
    create_table :categoria_pois do |t|
      t.string :nombre, null: false

      t.timestamps
    end
  end
end
