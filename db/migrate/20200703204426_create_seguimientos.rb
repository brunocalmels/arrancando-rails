class CreateSeguimientos < ActiveRecord::Migration[6.0]
  def change
    create_table :seguimientos do |t|
      t.references :seguidor, required: true, null: false, foreign_key: { to_table: :users }
      t.references :seguido, required: true, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
