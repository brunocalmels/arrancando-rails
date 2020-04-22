class SubcategoriaReceta < ApplicationRecord
  has_and_belongs_to_many :recetas,
                          class_name: "Receta",
                          join_table: "recetas_subcategoria_recetas"

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
    ]
  )

  scope :search_query, lambda { |query|
    where(
      "LOWER(nombre) LIKE ?",
      "%#{query.to_s.downcase}%"
    )
  }
end
