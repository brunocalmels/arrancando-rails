class AddUsernamesPasadosToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :usernames_pasados, :string, array: true, index: true, default: []
  end
end
