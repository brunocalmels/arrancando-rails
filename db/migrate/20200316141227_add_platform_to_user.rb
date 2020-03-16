class AddPlatformToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :platform, :string
  end
end
