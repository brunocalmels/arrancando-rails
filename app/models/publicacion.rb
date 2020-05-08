# == Schema Information
#
# Table name: publicaciones
#
#  id                       :integer          not null, primary key
#  titulo                   :string           not null
#  cuerpo                   :text             not null
#  puntajes                 :jsonb            default("{}")
#  user_id                  :integer          not null
#  ciudad_id                :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  habilitado               :boolean          default("true")
#  categoria_publicacion_id :integer          default("1"), not null
#

class Publicacion < ApplicationRecord
  belongs_to :ciudad
  belongs_to :user
  belongs_to :categoria_publicacion
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 10

  has_many :comentarios,
           dependent: :destroy,
           class_name: "ComentarioPublicacion"

  validates :titulo, presence: true
  validates :cuerpo, presence: true
  validate :attachments_max_length, unless: -> { user.unlim_upload? }
  validate :attachments_present

  scope :habilitados, lambda {
    where(habilitado: true)
  }

  scope :last_month, lambda {
    where("publicaciones.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :current_month, lambda {
    where("publicaciones.created_at > ? ", Time.zone.now.at_beginning_of_month)
  }

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
      categoria_publicacion_id
      ciudad_id
      user_id
      sorted_by
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    direction = "desc"
    publicaciones = Publicacion.arel_table
    case sort_option.to_s
    when "fecha"
      order(publicaciones[:updated_at].send(direction))
    when "puntuacion"
      # rubocop:disable Metrics/LineLength
      q = 'SELECT publicaciones.id from publicaciones left join (SELECT id, avg(value::FLOAT) FROM "publicaciones" JOIN jsonb_each(puntajes) d on true GROUP BY "publicaciones"."id") complex on publicaciones.id = complex.id order by avg desc nulls last'
      ids = ActiveRecord::Base.connection.execute(q).pluck "id"
      Publicacion.where(id: ids).order_by_ids(ids)
      # rubocop:enable Metrics/LineLength
    else
      raise(ArgumentError,
            "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :search_query, lambda { |query|
    where(
      "LOWER(titulo) LIKE ?
      OR LOWER(cuerpo) LIKE ?",
      "%#{query.to_s.downcase}%",
      "%#{query.to_s.downcase}%"
    )
  }

  scope :categoria_publicacion_id, lambda { |categoria_publicacion_id|
    where(categoria_publicacion_id: categoria_publicacion_id)
  }

  scope :user_id, lambda { |user_id|
    where(user_id: user_id)
  }

  scope :ciudad_id, lambda { |ciudad_id|
    where(ciudad_id: ciudad_id)
  }

  def my_puntajes
    puntajes.map do |k, v|
      { usuario: { id: k.to_i }, puntaje: v }
    end
  end

  def self.order_by_ids(ids)
    order_by = ["CASE"]
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
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
