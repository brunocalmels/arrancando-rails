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

  def my_puntajes
    puntajes.map do |k, v|
      { usuario: { id: k.to_i }, puntaje: v }
    end
  end

  private

  def attachments_max_length
    imagenes.each do |att|
      next unless att.byte_size > MAX_ATTACHMENT_SIZE_BYTES

      size = MAX_ATTACHMENT_SIZE_BYTES / 1.megabytes

      errors.add(
        :archivos,
        "Los archivos no pueden pesar más de #{size} MB."
      )
      break
    end
  end
end
