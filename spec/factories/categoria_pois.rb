# == Schema Information
#
# Table name: categoria_pois
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :categoria_poi do
    nombre { "MyString" }
  end
end
