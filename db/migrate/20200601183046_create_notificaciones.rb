class CreateNotificaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :notificaciones do |t|
      t.string :titulo, null: false
      t.text :cuerpo
      t.string :url
      t.boolean :leido, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
