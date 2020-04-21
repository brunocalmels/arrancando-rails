# == Schema Information
#
# Table name: ingredientes
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :ingrediente do
    nombre { "MyString" }
  end
end
