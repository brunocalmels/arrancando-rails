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
#  introduccion        :text
#  ingredientes        :text
#  instrucciones       :text
#  habilitado          :boolean          default("true")
#  duracion            :integer
#  complejidad         :string
#  ingredientes_items  :jsonb            default("[]")
#  vistas              :integer          default("0")
#  saved               :integer          default("{}"), is an Array
#

class Receta < ApplicationRecord
  include ContentHelper

  belongs_to :categoria_receta
  has_many :subcategoria_recetas
  belongs_to :user
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 10

  has_many :comentarios,
           dependent: :destroy,
           class_name: "ComentarioReceta"

  # has_and_belongs_to_many :ingredientes_items,
  #                         class_name: "Ingrediente",
  #                         join_table: "ingredientes_recetas"

  has_and_belongs_to_many :subcategoria_recetas,
                          class_name: "SubcategoriaReceta",
                          join_table: "recetas_subcategoria_recetas"

  validates :titulo, presence: true
  # validates :cuerpo, presence: true
  validate :attachments_max_length, unless: -> { user.unlim_upload? }
  validate :complejidad_inclusion
  validate :attachments_present, on: :create unless Rails.env.test?

  scope :habilitados, lambda {
    where(habilitado: true)
  }

  scope :last_month, lambda {
    where("recetas.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :current_month, lambda {
    where("recetas.created_at > ? ", Time.zone.now.at_beginning_of_month)
  }

  scope :search, lambda { |term|
    where(
      "titulo ILIKE :term OR
      cuerpo ILIKE :term OR
      introduccion ILIKE :term OR
      ingredientes ILIKE :term OR
      instrucciones ILIKE :term OR
      username ILIKE :term",
      term: "%#{term}%"
    ).joins(:user)
  }

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
      categoria_receta_id
      user_id
      sorted_by
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    direction = "desc"
    recetas = Receta.arel_table
    case sort_option.to_s
    when "vistas"
      order(recetas[:vistas].send(direction))
    when "fecha_actualizacion"
      order(recetas[:updated_at].send(direction))
    when "fecha_creacion"
      order(recetas[:created_at].send(direction))
    when "fecha"
      order(recetas[:created_at].send(direction))
    when "puntuacion"
      # rubocop:disable Metrics/LineLength
      q = 'SELECT recetas.id, avg, cant_punt, coms from recetas LEFT JOIN  ( SELECT id, avg(value::FLOAT), count(*) as cant_punt FROM "recetas" LEFT JOIN jsonb_each(puntajes) d ON true GROUP BY "recetas"."id" ) complex ON recetas.id = complex.id LEFT JOIN ( SELECT receta_id, count(*) AS coms FROM comentario_recetas GROUP BY receta_id ) comms_pub ON recetas.id = comms_pub.receta_id ORDER BY avg DESC nulls LAST, cant_punt DESC nulls LAST, coms DESC nulls LAST'
      ids = ActiveRecord::Base.connection.execute(q).pluck "id"
      Receta.where(id: ids).order_by_ids(ids)
      # rubocop:enable Metrics/LineLength
    else
      raise(ArgumentError,
            "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :search_query, lambda { |query|
    where(
      "titulo ILIKE :term OR
      cuerpo ILIKE :term OR
      introduccion ILIKE :term OR
      ingredientes ILIKE :term OR
      instrucciones ILIKE :term OR
      username ILIKE :term",
      term: "%#{query.downcase}%"
    ).joins(:user)
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

  def self.order_by_ids(ids)
    order_by = ["CASE"]
    ids.each_with_index do |id, index|
      order_by << "WHEN recetas.id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end

  def likes_color
    likes_color_object(self)
  end

  def self.likes(user_id)
    query = ContentHelper.query_for_likes(user_id, "recetas")
    (ActiveRecord::Base.connection.execute(query).pluck "suma")[0].to_i
  end

  private

  def attachments_present
    return if imagenes.attached?

    errors.add(
      :archivos,
      "La receta debe incluir al menos una imagen o video."
    )
  end

  def complejidad_inclusion
    return if complejidad.nil?
    return if complejidad.in? COMPLEJIDADES_RECETAS

    errors.add(:complejidad, "debe ser una de: #{COMPLEJIDADES_RECETAS}")
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
