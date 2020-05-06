class AddUnlimUploadToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :unlim_upload, :boolean, default: false
  end
end
