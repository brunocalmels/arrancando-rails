class CategoriaPublicacion < ApplicationRecord
  validates :nombre, presence: true, uniqueness: true

  def self.comunidad
    where(nombre: "Comunidad").first
  end
end
