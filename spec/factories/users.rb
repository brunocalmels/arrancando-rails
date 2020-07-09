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

FactoryBot.define do
  factory :user do
    nombre { Faker::Name.first_name }
    apellido { Faker::Name.last_name }
    username { "#{nombre.downcase}_#{apellido.downcase}" }
    email { Faker::Internet.email }
    password { "123456" }
  end
end
