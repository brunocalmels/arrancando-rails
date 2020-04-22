class CreateJoinTableSubcatRecetas < ActiveRecord::Migration[6.0]
  def change
    create_join_table :recetas, :subcategoria_recetas do |t|
      t.index %i[subcategoria_receta_id receta_id], name: "index_subcats_recetas_unique", unique: true
      t.index %i[receta_id subcategoria_receta_id], name: "index_recetas_subcats_recetas_unique", unique: true
    end
  end
end
