class CreateJoinTableIngredientesRecetas < ActiveRecord::Migration[6.0]
  def change
    create_join_table :ingredientes, :recetas do |t|
      t.index %i[ingrediente_id receta_id]
      t.index %i[receta_id ingrediente_id]
    end
  end
end
