class CreateSubcategoriaRecetas < ActiveRecord::Migration[6.0]
  def up
    create_table :subcategoria_recetas do |t|
      t.string :nombre, null: false

      t.timestamps
    end

    SUBCATEGORIAS_RECETAS.each do |subc|
      SubcategoriaReceta.create(nombre: subc)
    end
  end

  def down
    drop_table :subcategoria_recetas
  end
end
