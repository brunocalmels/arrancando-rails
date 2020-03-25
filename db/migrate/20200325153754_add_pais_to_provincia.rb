class AddPaisToProvincia < ActiveRecord::Migration[6.0]
  def change
    add_reference :provincias, :pais, null: false, default: Pais.argentina&.id || 0, foreign_key: true
  end
end
