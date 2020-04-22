# == Schema Information
#
# Table name: provincias
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pais_id    :integer          default("1"), not null
#

class Provincia < ApplicationRecord
  has_many :ciudades, dependent: :destroy
  belongs_to :pais
  paginates_per 20

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
      pais_id
    ]
  )

  scope :search_query, lambda { |query|
    where(
      "LOWER(nombre) LIKE ?",
      "%#{query.to_s.downcase}%"
    )
  }

  scope :pais_id, lambda { |pais_id|
    where(pais_id: pais_id)
  }

  def nombre_con_pais
    nombre + " (" + pais.nombre + ")"
  end
end
