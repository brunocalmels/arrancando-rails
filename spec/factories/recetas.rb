# == Schema Information
#
# Table name: recetas
#
#  id                  :integer          not null, primary key
#  titulo              :string           not null
#  cuerpo              :text
#  puntajes            :jsonb            default("{}")
#  user_id             :integer          not null
#  categoria_receta_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  introduccion        :text
#  ingredientes        :text
#  instrucciones       :text
#  habilitado          :boolean          default("true")
#  duracion            :integer
#  complejidad         :string
#  ingredientes_items  :jsonb            default("[]")
#  vistas              :integer          default("0")
#  saved               :integer          default("{}"), is an Array
#

FactoryBot.define do
  factory :receta do
    titulo { Faker::Dessert.variety }
    cuerpo { Faker::Restaurant.description }
    puntajes { {} }
    user { User.all.sample }
    categoria_receta do
      if CategoriaReceta.any?
        CategoriaReceta.all.sample
      else
        CategoriaReceta.create(nombre: "Asador")
      end
    end
  end
end
