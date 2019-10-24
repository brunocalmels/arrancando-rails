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

class User < ApplicationRecord
  enum rol: { normal: 0, admin: 1 }

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true
  # validates :nombre, presence: true
  # validates :apellido, presence: true
  has_secure_password
end
