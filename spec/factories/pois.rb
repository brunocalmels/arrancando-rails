FactoryBot.define do
  factory :poi do
    titulo { Faker::Restaurant.name }
    cuerpo { Faker::Restaurant.description }
    # Ubicación en la zona del Alto Valle
    lat { -38.8286134 + rand * (-38.981255 + 38.8286134) }
    # latitud { Faker::Address.latitude }
    long { -67.923975 + rand * (-68.2923527 + 67.923975) }
    puntaje { "" }
    categoria_poi { CategoriaPoi.all.sample }
  end
end
