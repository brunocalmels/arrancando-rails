# == Schema Information
#
# Table name: pois
#
#  id               :integer          not null, primary key
#  titulo           :string           not null
#  cuerpo           :text
#  lat              :float            not null
#  long             :float            not null
#  puntajes         :jsonb            default("{}")
#  user_id          :integer          not null
#  categoria_poi_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  direccion        :string
#  habilitado       :boolean          default("true")
#

class Poi < ApplicationRecord
  belongs_to :categoria_poi
  belongs_to :user
  belongs_to :ciudad, optional: true
  has_many_attached :imagenes
  has_rich_text :cuerpo_rich
  paginates_per 10

  validates :titulo, presence: true
  validates :lat, presence: true
  validates :long, presence: true
  validate :attachments_max_length

  scope :habilitados, lambda {
    where(habilitado: true)
  }

  scope :last_month, lambda {
    where("pois.created_at > ? ", Time.zone.now - 1.month)
  }

  scope :search, lambda { |term|
    where("titulo ILIKE :term OR cuerpo ILIKE :term", term: "%#{term}%")
  }

  filterrific(
    persistance_id: false,
    available_filters: %i[
      search_query
      categoria_poi_id
      user_id
      sorted_by
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    direction = "desc"
    pois = Poi.arel_table
    case sort_option.to_s
    when "proximidad"
      order(pois[:created_at].send(direction))
      # TODO: Filtrar por proximidad
    when "puntuacion"
      # rubocop:disable Metrics/LineLength
      q = 'SELECT pois.id from pois left join (SELECT id, avg(value::FLOAT) FROM "pois" JOIN jsonb_each(puntajes) d on true GROUP BY "pois"."id") complex on pois.id = complex.id order by avg desc nulls last'
      ids = ActiveRecord::Base.connection.execute(q).pluck "id"
      Poi.where(id: ids).order_by_ids(ids)
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

  scope :categoria_poi_id, lambda { |categoria_poi_id|
    where(categoria_poi_id: categoria_poi_id)
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
