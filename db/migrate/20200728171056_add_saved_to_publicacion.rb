class AddSavedToPublicacion < ActiveRecord::Migration[6.0]
  def change
    add_column :publicaciones, :saved, :integer, array: true, default: []
  end
end
