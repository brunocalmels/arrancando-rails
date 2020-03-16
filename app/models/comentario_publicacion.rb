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
#

class ComentarioPublicacion < ApplicationRecord
  belongs_to :publicacion
  belongs_to :user

  validates :mensaje, presence: true

  scope :last_month, lambda {
    where("comentario_publicaciones.created_at > ? ", Time.zone.now - 1.month)
  }
end
