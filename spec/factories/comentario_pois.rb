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
#  puntajes   :jsonb            default("{}")
#

FactoryBot.define do
  factory :comentario_poi do
    poi { nil }
    user { nil }
    mensaje { "MyText" }
  end
end
