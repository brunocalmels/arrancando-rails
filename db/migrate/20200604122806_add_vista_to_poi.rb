class AddVistaToPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :pois, :vistas, :bigint, default: 0
  end
end
