# == Schema Information
#
# Table name: reportes
#
#  id         :integer          not null, primary key
#  contenido  :text             default(""), not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reporte < ApplicationRecord
  belongs_to :user

  def contenido_short
    return contenido if contenido.length <= MAX_REPORTE_SHORT_LENGTH

    contenido[0..MAX_REPORTE_SHORT_LENGTH - 1] + "..."
  end
end
