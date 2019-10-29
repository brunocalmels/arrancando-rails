FactoryBot.define do
  factory :receta do
    titulo { Faker::Dessert.variety }
    cuerpo { Faker::Restaurant.description }
    puntaje { "" }
    categoria_receta { CategoriaReceta.all.sample }
  end
end
