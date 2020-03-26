class CreateCategoriaPublicaciones < ActiveRecord::Migration[6.0]
  def up
    create_table :categoria_publicaciones do |t|
      t.string :nombre, null: false

      t.timestamps
    end

    CATEGORIAS_PUBLICACIONES.each do |cat|
      CategoriaPublicacion.create(nombre: cat)
    end
  end

  def down
    drop_table :categoria_publicaciones
  end
end
