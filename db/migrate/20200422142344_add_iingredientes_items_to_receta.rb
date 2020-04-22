class AddIingredientesItemsToReceta < ActiveRecord::Migration[6.0]
  def change
    add_column :recetas, :ingredientes_items, :jsonb, default: {}
  end
end
