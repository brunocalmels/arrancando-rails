# == Schema Information
#
# Table name: publicaciones
#
#  id         :integer          not null, primary key
#  titulo     :string           not null
#  cuerpo     :text             not null
#  puntajes   :jsonb
#  ciudad_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :publicacion do
    titulo { Faker::Hipster.sentence(word_count: 1)  }
    cuerpo { Faker::Hipster.sentence(word_count: 40) }
    puntajes { {} }
    user { User.all.sample }
    ciudad { Ciudad.all.sample }
  end
end
