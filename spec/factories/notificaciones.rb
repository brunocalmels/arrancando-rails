# == Schema Information
#
# Table name: notificaciones
#
#  id         :integer          not null, primary key
#  titulo     :string           not null
#  cuerpo     :text
#  url        :string
#  leido      :boolean          default("false")
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :notificacion do
    titulo { "MyString" }
    cuerpo { "MyText" }
    url { "MyString" }
    leido { false }
    user { User.any? ? User.all.sample : FactoryBot.create(:user) }
  end
end
