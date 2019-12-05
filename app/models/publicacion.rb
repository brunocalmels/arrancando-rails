# == Schema Information
#
# Table name: publicaciones
#
#  id         :integer          not null, primary key
#  titulo     :string           not null
#  cuerpo     :text             not null
#  puntajes   :jsonb
#  ciudad_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Publicacion < ApplicationRecord
  belongs_to :ciudad
  belongs_to :user
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 10

  validates :titulo, presence: true
  validates :cuerpo, presence: true
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
