class AddWhatsappToPoi < ActiveRecord::Migration[6.0]
  def change
    add_column :pois, :whatsapp, :bigint
  end
end
