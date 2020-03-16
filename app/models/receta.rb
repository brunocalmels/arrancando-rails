# == Schema Information
#
# Table name: recetas
#
#  id                  :integer          not null, primary key
#  titulo              :string           not null
#  cuerpo              :text
#  puntajes            :jsonb            default("{}")
#  user_id             :integer          not null
#  categoria_receta_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Receta < ApplicationRecord
  belongs_to :categoria_receta
  belongs_to :user
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 10

  has_many :comentarios,
           dependent: :destroy,
           class_name: "ComentarioReceta"

  validates :titulo, presence: true
  # validates :cuerpo, presence: true
  validate :attachments_max_length

  scope :habilitados, lambda {
    where(habilitado: true)
  }

  scope :last_month, lambda {
    where("recetas.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
      categoria_receta_id
      user_id
    ]
  )
  scope :search_query, lambda { |query|
    where(
      "LOWER(titulo) LIKE ?
      OR LOWER(cuerpo) LIKE ?",
      "%#{query.to_s.downcase}%",
      "%#{query.to_s.downcase}%"
    )
  }

  scope :user_id, lambda { |user_id|
    where(user_id: user_id)
  }

  scope :categoria_receta_id, lambda { |categoria_receta_id|
    where(categoria_receta_id: categoria_receta_id)
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
