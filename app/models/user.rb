# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string
#  nombre          :string
#  apellido        :string
#  username        :string
#  telefono        :integer
#  rol             :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  activo          :boolean
#

class User < ApplicationRecord
  enum rol: { normal: 0, admin: 1 }

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true
  # validates :nombre, presence: true
  # validates :apellido, presence: true
  has_secure_password

  has_one_attached :avatar
  # validates :avatar, content_type: ["image/png", "image/jpeg"]

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

  # rubocop: enable Naming/AccessorMethodName
end
