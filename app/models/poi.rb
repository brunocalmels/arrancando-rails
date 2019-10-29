class Poi < ApplicationRecord
  belongs_to :categoria_poi

  has_rich_text :cuerpo_rich

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }
end
