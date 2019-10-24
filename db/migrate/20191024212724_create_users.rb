class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest
      t.string :nombre
      t.string :apellido
      t.string :username
      t.bigint :telefono
      t.integer :rol

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :username
  end
end
