class Publicacion < ApplicationRecord
  belongs_to :ciudad

  has_rich_text :cuerpo_rich
  paginates_per 10

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }
end
