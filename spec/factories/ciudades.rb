# == Schema Information
#
# Table name: ciudades
#
#  id           :integer          not null, primary key
#  nombre       :string           not null
#  provincia_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :ciudad do
    nombre { "MyString" }
    provincia { nil }
  end
end
