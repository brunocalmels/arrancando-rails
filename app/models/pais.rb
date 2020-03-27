# == Schema Information
#
# Table name: paises
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Pais < ApplicationRecord
  has_many :provincias

  validates :nombre, presence: true, uniqueness: true

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

  def self.argentina
    where(nombre: "Argentina").first
  end
end
