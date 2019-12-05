# == Schema Information
#
# Table name: pois
#
#  id               :integer          not null, primary key
#  titulo           :string           not null
#  cuerpo           :text
#  lat              :float            not null
#  long             :float            not null
#  puntaje          :jsonb
#  categoria_poi_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  geo_point        :geography({:srid point, 4326
#

class Poi < ApplicationRecord
  belongs_to :categoria_poi
  belongs_to :user
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 10

  validates :titulo, presence: true
  validates :lat, presence: true
  validates :long, presence: true
  validate :attachments_max_length

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }

  private

  def attachments_max_length
    imagenes.each do |att|
      next unless att.byte_size > MAX_ATTACHMENT_SIZE_BYTES

      errors.add(
        :archivos,
        "No pueden pesar más de #{MAX_ATTACHMENT_SIZE_BYTES / 1.megabytes} MB."
      )
      break
    end
  end
end
