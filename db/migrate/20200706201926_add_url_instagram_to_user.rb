class AddUrlInstagramToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :url_instagram, :string
  end
end
