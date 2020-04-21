class AddDuracionAndComplejidadToReceta < ActiveRecord::Migration[6.0]
  def change
    add_column :recetas, :duracion, :integer
    add_column :recetas, :complejidad, :string
  end
end
