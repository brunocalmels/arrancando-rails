# == Schema Information
#
# Table name: comentario_pois
#
#  id         :integer          not null, primary key
#  poi_id     :integer          not null
#  user_id    :integer          not null
#  mensaje    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ComentarioPoi < ApplicationRecord
  belongs_to :poi, touch: true
  belongs_to :user

  validates :mensaje, presence: true

  scope :last_month, lambda {
    where("comentario_pois.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :current_month, lambda {
    where("comentario_pois.created_at > ? ",
          Time.zone.now.at_beginning_of_month)
  }
end
