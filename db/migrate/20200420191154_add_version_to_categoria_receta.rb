class AddVersionToCategoriaReceta < ActiveRecord::Migration[6.0]
  def up
    add_column :categoria_recetas, :version, :integer, null: false, default: 1

    CATEGORIAS_RECETAS_V2.each do |cat|
      CategoriaReceta.create(nombre: cat, version: 2)
    end
  end

  def down
    CATEGORIAS_RECETAS_V2.each do |cat|
      catv2 = CategoriaReceta.where(nombre: cat).where(version: 2).first
      catv2&.destroy
    end

    remove_column :categoria_recetas, :version
  end
end
