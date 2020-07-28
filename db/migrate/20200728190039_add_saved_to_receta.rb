class AddSavedToReceta < ActiveRecord::Migration[6.0]
  def change
    add_column :recetas, :saved, :integer, array: true, default: []
  end
end
