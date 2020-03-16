# == Schema Information
#
# Table name: ciudades
#
#  id           :integer          not null, primary key
#  nombre       :string           not null
#  provincia_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  populada     :boolean          default("false")
#

class Ciudad < ApplicationRecord
  belongs_to :provincia
  has_many :publicaciones, dependent: :nullify
  has_many :users, dependent: :nullify
  paginates_per 20

  scope :search, lambda { |term|
    where("nombre ILIKE :term", term: "%#{term}%")
  }

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
      provincia_id
    ]
  )

  scope :search_query, lambda { |query|
    where(
      "LOWER(nombre) LIKE ?",
      "%#{query.to_s.downcase}%"
    )
  }

  scope :provincia_id, lambda { |provincia_id|
    where(provincia_id: provincia_id)
  }

  def nombre_con_provincia
    nombre + " (" + provincia.nombre + ")"
  end
end
