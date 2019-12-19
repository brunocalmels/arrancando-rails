class SetDefaultUserRol < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :rol, :integer, default: 0
  end
end
