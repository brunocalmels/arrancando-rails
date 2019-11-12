class CreateRecetas < ActiveRecord::Migration[6.0]
  def change
    create_table :recetas do |t|
      t.string :titulo, null: false
      t.text :cuerpo
      t.jsonb :puntajes, default: {}
      t.references :user, null: false, foreign_key: true
      t.references :categoria_receta, null: false, foreign_key: true

      t.timestamps
    end
    add_index :recetas, :titulo
  end
end
