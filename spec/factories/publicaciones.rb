# == Schema Information
#
# Table name: publicaciones
#
#  id                       :integer          not null, primary key
#  titulo                   :string           not null
#  cuerpo                   :text             not null
#  puntajes                 :jsonb            default("{}")
#  user_id                  :integer          not null
#  ciudad_id                :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  habilitado               :boolean          default("true")
#  categoria_publicacion_id :integer          default("1"), not null
#  vistas                   :integer          default("0")
#  saved                    :integer          default("{}"), is an Array
#

FactoryBot.define do
  factory :publicacion do
    titulo { Faker::Hipster.sentence(word_count: 1) }
    cuerpo { Faker::Hipster.sentence(word_count: 40) }
    puntajes { {} }
    user { User.all.sample || FactoryBot.create(:user) }
    ciudad { Ciudad.all.sample }
    categoria_publicacion do
      if CategoriaPublicacion.any?
        CategoriaPublicacion.all.sample
      else
        CategoriaPublicacion.create(nombre: "Asador")
      end
    end
  end
end
