# == Schema Information
#
# Table name: comentario_publicaciones
#
#  id             :integer          not null, primary key
#  publicacion_id :integer          not null
#  user_id        :integer          not null
#  mensaje        :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  puntajes       :jsonb            default("{}")
#

class ComentarioPublicacion < ApplicationRecord
  include ComentarioHelper

  belongs_to :publicacion, touch: true
  belongs_to :user

  validates :mensaje, presence: true

  scope :last_month, lambda {
    where("comentario_publicaciones.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :current_month, lambda {
    where("comentario_publicaciones.created_at > ? ",
          Time.zone.now.at_beginning_of_month)
  }

  def my_puntajes
    comment_my_puntajes(self)
  end

  def ref_id
    publicacion.id
  end
end
