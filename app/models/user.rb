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
#

class User < ApplicationRecord
  before_save :store_username

  enum rol: { normal: 0, admin: 1 }

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true
  validate :not_used_username
  has_secure_password

  has_one_attached :avatar
  # validates :avatar, content_type: ["image/png", "image/jpeg"]

  has_many :publicaciones, dependent: :destroy
  has_many :recetas, dependent: :destroy
  has_many :pois, dependent: :destroy

  scope :admins, -> { where(rol: :admin) }
  scope :normales, -> { where(rol: :normal) }

  filterrific(
    persistance_id: false,
    # default_filter_params: { order(apellido: :asc).order(nombres: :asc) },
    available_filters: [
      :search_query
    ]
  )
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

  # rubocop: disable Naming/AccessorMethodName
  # TODO: Arreglar esto
  def set_avatar(avatar)
    tempfile = Tempfile.new("fileupload")
    tempfile.binmode
    tempfile.write(Base64.decode64(avatar))
    tempfile.rewind

    mime_type = Mime::Type
                .lookup_by_extension(File.extname("filename.jpg")[1..-1])
                .to_s
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: tempfile,
      filename: "filename.jpg",
      type: mime_type
    )
    self.avatar.attach(uploaded_file)
  end

  def grab_image(url)
    downloaded_image = URI.parse(url).open
    avatar.attach(io: downloaded_image, filename: "downloaded.jpg")
  end

  # rubocop: enable Naming/AccessorMethodName

  private

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
