class AddCiudadAndAppVersionToUser < ActiveRecord::Migration[6.0]
  def change
    # add_reference :users, :ciudad, null: false, foreign_key: true, default: 1
    # add_column :users, :app_version, :string
  end
end
