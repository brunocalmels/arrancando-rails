FactoryBot.define do
  factory :publicacion do
    titulo { Faker::Hipster.sentence(word_count: 1)  }
    cuerpo { Faker::Hipster.sentence(word_count: 40) }
    puntajes { "" }
    ciudad { Ciudad.all.sample }
  end
end
