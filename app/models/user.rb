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
#

class User < ApplicationRecord
  include UsersHelper

  before_save :store_username

  enum rol: { normal: 0, admin: 1 }

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true
  validate :not_used_username
  has_secure_password

  has_one_attached :avatar
  # validates :avatar, content_type: ["image/png", "image/jpeg"]

  belongs_to :ciudad
  has_many :publicaciones, dependent: :destroy
  has_many :recetas, dependent: :destroy
  has_many :pois, dependent: :destroy
  has_many :comentario_publicaciones, dependent: :destroy
  has_many :comentario_recetas, dependent: :destroy

  paginates_per 20

  scope :admins, -> { where(rol: :admin) }
  scope :normales, -> { where(rol: :normal) }
  scope :rol, lambda { |rol|
    where(rol: rol)
  }
  scope :rankeables, -> { where(rankeable: true) }

  filterrific(
    persistance_id: false,
    # default_filter_params: { order(apellido: :asc).order(nombres: :asc) },
    available_filters: %i[
      search_query
      ciudad_id
      rol
      sorted_by
    ]
  )

  scope :ciudad_id, lambda { |ciudad_id|
    where(ciudad_id: ciudad_id)
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
      "LOWER(apellido) LIKE ?
      OR LOWER(nombre) LIKE ?
      OR LOWER(username) LIKE ?",
      "%#{query.to_s.downcase}%",
      "%#{query.to_s.downcase}%",
      "%#{query.to_s.downcase}%"
    )
  }

  def puntaje
    2 * publicaciones.count +
      4 * recetas.count +
      3 * pois.count +
      comentarios
  end

  def puntaje_mensual
    2 * publicaciones.current_month.count +
      4 * recetas.current_month.count +
      3 * pois.current_month.count +
      comentarios_current_month
  end

  def comentarios
    comentario_publicaciones.count + comentario_recetas.count
  end

  def comentarios_last_month
    comentario_publicaciones.last_month.count +
      comentario_recetas.last_month.count
  end

  def comentarios_current_month
    comentario_publicaciones.current_month.count +
      comentario_recetas.current_month.count
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

  def not_used_username
    unless username.in? User
           .where("id != ?", id)
           .pluck(:usernames_pasados)
           .flatten
      return
    end

    errors.add(:username, "Ya utilizado")
  end
end
