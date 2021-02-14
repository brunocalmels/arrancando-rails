# == Schema Information
#
# Table name: paises
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :pais do
    nombre { %w[Argentina Brasil Chile].sample }
  end
end
