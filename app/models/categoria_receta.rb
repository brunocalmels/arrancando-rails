# == Schema Information
#
# Table name: categoria_recetas
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CategoriaReceta < ApplicationRecord
  has_many :recetas
  validates :nombre, presence: true, uniqueness: true
end
