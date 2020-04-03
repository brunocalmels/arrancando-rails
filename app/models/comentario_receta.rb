# == Schema Information
#
# Table name: comentario_recetas
#
#  id         :integer          not null, primary key
#  receta_id  :integer          not null
#  user_id    :integer          not null
#  mensaje    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ComentarioReceta < ApplicationRecord
  belongs_to :receta
  belongs_to :user

  validates :mensaje, presence: true

  scope :last_month, lambda {
    where("comentario_recetas.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :current_month, lambda {
    where("comentario_recetas.created_at > ? ",
          Time.zone.now.at_beginning_of_month)
  }
end
