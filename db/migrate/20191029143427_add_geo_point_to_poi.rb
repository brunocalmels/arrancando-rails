class AddGeoPointToPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :pois, :geo_point, :st_point, geographic: true
    add_index :pois, :geo_point, using: :gist
  end
end
