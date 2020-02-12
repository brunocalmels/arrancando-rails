class CreateReportes < ActiveRecord::Migration[6.0]
  def change
    create_table :reportes do |t|
      t.text :contenido, null: false, default: ""
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
