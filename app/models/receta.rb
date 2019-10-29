class Receta < ApplicationRecord
  belongs_to :categoria_receta

  has_rich_text :cuerpo_rich

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }
end
