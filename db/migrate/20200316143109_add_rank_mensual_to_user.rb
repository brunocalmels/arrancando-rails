class AddRankMensualToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rank_mensual, :integer
  end
end
