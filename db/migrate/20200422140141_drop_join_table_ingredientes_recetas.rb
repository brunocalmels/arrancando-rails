class DropJoinTableIngredientesRecetas < ActiveRecord::Migration[6.0]
  def up
    drop_table :ingredientes_recetas
  end

  def down
    create_join_table :ingredientes, :recetas do |t|
      t.index %i[ingrediente_id receta_id]
      t.index %i[receta_id ingrediente_id]
    end
  end
end
