class CreateComentarioPublicaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :comentario_publicaciones do |t|
      t.references :publicacion, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :mensaje, null: false

      t.timestamps
    end
  end
end
