class RemoveGeoPointFromPois < ActiveRecord::Migration[6.0]
  def change
    remove_index :pois, :geo_point
    remove_column :pois, :geo_point, :st_point, geographic: true
  end
end
