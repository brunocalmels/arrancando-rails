class ChangeDefaultIngredientesItemsRecetas < ActiveRecord::Migration[6.0]
  def change
    remove_column :recetas, :ingredientes_items, :jsonb, default: {}
    add_column :recetas, :ingredientes_items, :jsonb, default: []
  end
end
