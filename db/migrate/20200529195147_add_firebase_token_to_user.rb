class AddFirebaseTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :firebase_token, :string
  end
end
