class AddRankToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rank, :integer
  end
end
