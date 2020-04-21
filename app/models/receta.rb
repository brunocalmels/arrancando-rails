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

  has_and_belongs_to_many :ingredientes_items,
                          class_name: "Ingrediente",
                          join_table: "ingredientes_recetas"

  validates :titulo, presence: true
  # validates :cuerpo, presence: true
  validate :attachments_max_length
  validate :complejidad_inclusion

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
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
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
    when "fecha"
      order(recetas[:updated_at].send(direction))
    when "puntuacion"
      # rubocop:disable Metrics/LineLength
      q = 'SELECT recetas.id from recetas left join (SELECT id, avg(value::FLOAT) FROM "recetas" JOIN jsonb_each(puntajes) d on true GROUP BY "recetas"."id") complex on recetas.id = complex.id order by avg desc nulls last'
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

  def self.order_by_ids(ids)
    order_by = ["CASE"]
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end

  private

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
