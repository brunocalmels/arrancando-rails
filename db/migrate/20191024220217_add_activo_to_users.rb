class AddActivoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :activo, :boolean
  end
end
