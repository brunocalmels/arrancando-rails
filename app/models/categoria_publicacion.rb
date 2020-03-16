# == Schema Information
#
# Table name: categoria_publicaciones
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CategoriaPublicacion < ApplicationRecord
  has_many :publicaciones

  validates :nombre, presence: true, uniqueness: true

  def self.comunidad
    where(nombre: "Comunidad").first
  end
end
