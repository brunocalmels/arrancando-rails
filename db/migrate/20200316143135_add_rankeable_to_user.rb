class AddRankeableToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rankeable, :boolean, default: true
  end
end
