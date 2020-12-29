class CreateGrupoChats < ActiveRecord::Migration[6.0]
  def up
    create_table :grupo_chats do |t|
      t.string :simbolo, null: false
      t.string :color, null: false
      t.string :nombre, null: false

      t.timestamps
    end
    add_index :grupo_chats, :nombre

    GRUPOS_CHAT.each do |grupo|
      GrupoChat.create(
        nombre: grupo[:nombre],
        simbolo: grupo[:simbolo],
        color: grupo[:color]
      )
    end
  end

  def down
    drop_table :grupo_chats
  end
end
