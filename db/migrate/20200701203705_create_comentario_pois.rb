class CreateComentarioPois < ActiveRecord::Migration[6.0]
  def change
    create_table :comentario_pois do |t|
      t.references :poi, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :mensaje, null: false

      t.timestamps
    end
  end
end
