class CategoriaReceta < ApplicationRecord
  validates :nombre, presence: true
end
