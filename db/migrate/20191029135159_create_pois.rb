class CreatePois < ActiveRecord::Migration[6.0]
  def change
    create_table :pois do |t|
      t.string :titulo, null: false
      t.text :cuerpo
      t.float :lat, null: false
      t.float :long, null: false
      t.jsonb :puntajes, default: {}
      t.references :user, null: false, foreign_key: true
      t.references :categoria_poi, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pois, :titulo
  end
end
