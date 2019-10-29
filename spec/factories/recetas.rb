# == Schema Information
#
# Table name: recetas
#
#  id                  :integer          not null, primary key
#  titulo              :string           not null
#  cuerpo              :text
#  puntaje             :jsonb
#  categoria_receta_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :receta do
    titulo { Faker::Dessert.variety }
    cuerpo { Faker::Restaurant.description }
    puntaje { "" }
    categoria_receta { CategoriaReceta.all.sample }
  end
end
