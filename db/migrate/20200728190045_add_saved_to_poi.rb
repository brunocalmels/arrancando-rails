class AddSavedToPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :pois, :saved, :integer, array: true, default: []
  end
end
