# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string
#  nombre          :string
#  apellido        :string
#  username        :string
#  telefono        :integer
#  rol             :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  activo          :boolean
#

FactoryBot.define do
  factory :user do
  end
end
