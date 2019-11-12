class CreatePublicaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :publicaciones do |t|
      t.string :titulo, null: false
      t.text :cuerpo, null: false
      t.jsonb :puntajes, default: {}
      t.references :user, null: false, foreign_key: true
      t.references :ciudad, null: false, foreign_key: true

      t.timestamps
    end

    add_index :publicaciones, :titulo
  end
end
