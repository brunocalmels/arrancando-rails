# == Schema Information
#
# Table name: recetas
#
#  id                  :integer          not null, primary key
#  titulo              :string           not null
#  cuerpo              :text
#  puntaje             :jsonb
#  categoria_receta_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Receta < ApplicationRecord
  belongs_to :categoria_receta
  belongs_to :user
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 5

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
