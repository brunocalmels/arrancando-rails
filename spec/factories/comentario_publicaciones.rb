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

FactoryBot.define do
  factory :comentario_publicacion do
    publicacion { nil }
    user { nil }
    mensaje { "MyText" }
  end
end
