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
end
