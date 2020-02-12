class Reporte < ApplicationRecord
  belongs_to :user

  def contenido_short
    return contenido if contenido.length <= MAX_REPORTE_SHORT_LENGTH

    contenido[0..MAX_REPORTE_SHORT_LENGTH - 1] + "..."
  end
end
