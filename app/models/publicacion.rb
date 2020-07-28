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
#  vistas                   :integer          default("0")
#  saved                    :integer          default("{}"), is an Array
#

class Publicacion < ApplicationRecord
  include ContentHelper

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
  validate :attachments_present, on: :create

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
    where(
      "titulo ILIKE :term OR
      cuerpo ILIKE :term OR
      username ILIKE :term",
      term: "%#{term}%"
    ).joins(:user)
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
      q = 'SELECT publicaciones.id, avg, cant_punt, coms from publicaciones LEFT JOIN  ( SELECT id, avg(value::FLOAT), count(*) as cant_punt FROM "publicaciones" LEFT JOIN jsonb_each(puntajes) d ON true GROUP BY "publicaciones"."id" ) complex ON publicaciones.id = complex.id LEFT JOIN ( SELECT publicacion_id, count(*) AS coms FROM comentario_publicaciones GROUP BY publicacion_id ) comms_pub ON publicaciones.id = comms_pub.publicacion_id ORDER BY avg DESC nulls LAST, cant_punt DESC nulls LAST, coms DESC nulls LAST'
      # rubocop:enable Metrics/LineLength
      ids = ActiveRecord::Base.connection.execute(q).pluck "id"
      Publicacion.where(id: ids).order_by_ids(ids)
    else
      raise(ArgumentError,
            "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :search_query, lambda { |query|
    where(
      "titulo ILIKE :term OR
       cuerpo ILIKE :term OR
       users.username ILIKE :term",
      term: "%#{query.downcase}%"
    ).joins(:user)
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
      order_by << "WHEN publicaciones.id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end

  def likes_color
    likes_color_object(self)
  end

  private

  def attachments_present
    return if imagenes.attached?

    errors.add(
      :archivos,
      "La publicación debe incluir al menos una imagen o video."
    )
  end

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
