class CreateCategoriaRecetas < ActiveRecord::Migration[6.0]
  def change
    create_table :categoria_recetas do |t|
      t.string :nombre, null: false

      t.timestamps
    end
  end
end
