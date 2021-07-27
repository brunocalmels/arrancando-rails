# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string           not null
#  password_digest   :string
#  nombre            :string
#  apellido          :string
#  username          :string
#  telefono          :integer
#  rol               :integer          default("0")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  activo            :boolean
#  usernames_pasados :string           default("{}"), is an Array
#  last_seen_at      :datetime
#  rank              :integer
#  ciudad_id         :integer          default("1"), not null
#  app_version       :string
#  platform          :string
#  rank_mensual      :integer
#  rankeable         :boolean          default("true")
#  unlim_upload      :boolean          default("false")
#  firebase_token    :string
#  url_instagram     :string
#
class User < ApplicationRecord
  include UsersHelper
  include UsersMigrationHelper
  before_save :store_username
  enum rol: { normal: 0, admin: 1 }

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true
  # validate :not_used_username
  has_secure_password
  has_one_attached :avatar
  belongs_to :ciudad
  has_many :publicaciones, dependent: :destroy
  has_many :recetas, dependent: :destroy
  has_many :pois, dependent: :destroy
  has_many :comentario_publicaciones, dependent: :destroy
  has_many :comentario_recetas, dependent: :destroy
  has_many :comentario_pois, dependent: :destroy
  has_many :seguimientos, class_name: "Seguimiento", foreign_key: :seguidor
  has_many :seguidores, class_name: "Seguimiento", foreign_key: :seguido
  has_many :mensaje_chats

  paginates_per 25

  scope :admins, -> { where(rol: :admin) }
  scope :normales, -> { where(rol: :normal) }
  # scope :rol, lambda { |rol|
  #   where(rol: rol)
  # }
  scope :rankeables, -> { where(rankeable: true) }

  filterrific(
    persistance_id: false,
    # default_filter_params: { order(apellido: :asc).order(nombres: :asc) },
    available_filters: %i[
      search_query
      ciudad_id
      rol
      app_version
      platform
      sorted_by
    ]
  )

  scope :ciudad_id, lambda { |ciudad_id|
    where(ciudad_id: ciudad_id)
  }

  scope :app_version, lambda { |av|
    where(app_version: av)
  }

  scope :platform, lambda { |plat|
    where(platform: plat)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? "desc" : "asc"
    users = User.arel_table
    case sort_option.to_s
    when /^username_/
      order(users[:username].send(direction))
    when /^apellido_/
      order(users[:apellido].send(direction))
    when /^act_/
      order(users[:last_seen_at].send(direction))
    when /^ranking_mensual_/
      order(users[:rank_mensual].send(direction))
    when /^ranking_/
      order(users[:rank].send(direction))
    else
      raise(ArgumentError,
            "Invalid sort option: #{sort_option.inspect}")
    end
  }
  def self.options_for_sorted_by
    [
      ["Username (asc.)", "username_asc"],
      ["Username (desc.)", "username_desc"],
      ["Apellido (asc.)", "apellido_asc"],
      ["Apellido (desc.)", "apellido_desc"],
      ["Última act. (asc.)", "act_asc"],
      ["Última act. (desc.)", "act_desc"],
      ["Ranking (desc.)", "ranking_desc"],
      ["Ranking (asc.)", "ranking_asc"],
      ["Ranking mens. (desc.)", "ranking_mensual_desc"],
      ["Ranking mens. (asc.)", "ranking_mensual_asc"]
    ]
  end

  scope :search_query, lambda { |query|
    where(
      "LOWER(users.apellido) LIKE ?
      OR LOWER(users.nombre) LIKE ?
      OR LOWER(users.username) LIKE ?",
      "%#{query.to_s.downcase}%",
      "%#{query.to_s.downcase}%",
      "%#{query.to_s.downcase}%"
    )
  }

  # rubocop: disable Metrics/AbcSize
  def puntaje
    5 * publicaciones.count +
      10 * recetas.count +
      10 * pois.count +
      2 * comentarios +
      2 * comentarios_received +
      rated_5_stars(Publicacion) +
      rated_5_stars(Receta) +
      rated_5_stars(Poi) +
      weigh_for_5_star_items(publicaciones) +
      weigh_for_5_star_items(recetas)
  end

  def puntaje_mensual
    5 * publicaciones.current_month.count +
      10 * recetas.current_month.count +
      10 * pois.current_month.count +
      2 * comentarios("current_month") +
      2 * comentarios_received("current_month") +
      rated_5_stars(Publicacion.current_month) +
      rated_5_stars(Receta.current_month) +
      rated_5_stars(Poi.current_month) +
      weigh_for_5_star_items(publicaciones.current_month) +
      weigh_for_5_star_items(recetas.current_month)
  end

  def puntaje_last_month
    5 * publicaciones.last_month.count +
      10 * recetas.last_month.count +
      10 * pois.last_month.count +
      2 * comentarios("last_month") +
      2 * comentarios_received("last_month") +
      rated_5_stars(Publicacion.last_month) +
      rated_5_stars(Receta.last_month) +
      rated_5_stars(Poi.last_month) +
      weigh_for_5_star_items(publicaciones.last_month) +
      weigh_for_5_star_items(recetas.last_month)
  end

  # rubocop: enable Metrics/AbcSize

  def comentarios(scope="all")
    comentario_publicaciones.send(scope).count +
      comentario_recetas.send(scope).count
  end

  def comentarios_received(scope="all")
    ComentarioPublicacion
      .send(scope)
      .joins(:publicacion)
      .where("publicaciones.user_id = ?", id)
      .count +
      ComentarioReceta
      .send(scope)
      .joins(:receta)
      .where("recetas.user_id = ?", id)
      .count
  end

  private

  # Guarda el username para evitar que se repita en el futuro
  def store_username
    return unless username_changed?

    usernames_pasados.nil? ? self.usernames_pasados = [] : nil
    usernames_pasados << username
    return unless usernames_pasados.count > 10

    self.usernames_pasados = usernames_pasados.drop(1)
  end

  # def not_used_username
  #   unless username.in? User
  #          .where("id != ?", id)
  #          .pluck(:usernames_pasados)
  #          .flatten
  #     return
  #   end
  #   errors.add(:username, "Ya utilizado")
  # end
end
