class CategoriaPublicacion < ApplicationRecord
  has_many :publicaciones

  validates :nombre, presence: true, uniqueness: true

  def self.comunidad
    where(nombre: "Comunidad").first
  end
end
