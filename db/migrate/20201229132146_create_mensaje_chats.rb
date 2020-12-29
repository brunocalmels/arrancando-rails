class CreateMensajeChats < ActiveRecord::Migration[6.0]
  def change
    create_table :mensaje_chats do |t|
      t.references :grupo_chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :mensaje

      t.timestamps
    end
  end
end
