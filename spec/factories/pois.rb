# == Schema Information
#
# Table name: pois
#
#  id               :integer          not null, primary key
#  titulo           :string           not null
#  cuerpo           :text
#  lat              :float            not null
#  long             :float            not null
#  puntajes         :jsonb            default("{}")
#  user_id          :integer          not null
#  categoria_poi_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  direccion        :string
#  habilitado       :boolean          default("true")
#

FactoryBot.define do
  factory :poi do
    titulo { Faker::Restaurant.name }
    cuerpo { Faker::Restaurant.description }
    # Ubicación en la zona del Alto Valle
    lat { -38.8286134 + rand * (-38.981255 + 38.8286134) }
    # latitud { Faker::Address.latitude }
    long { -67.923975 + rand * (-68.2923527 + 67.923975) }
    direccion { %w[Urquiza Sarmiento Esmeralda].sample + " " + rand(1..1000).to_s }
    puntajes { {} }
    user { User.all.sample }
    categoria_poi { CategoriaPoi.all.sample }
  end
end
