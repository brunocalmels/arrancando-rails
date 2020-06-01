# == Schema Information
#
# Table name: notificaciones
#
#  id         :integer          not null, primary key
#  titulo     :string           not null
#  cuerpo     :text
#  url        :string
#  leido      :boolean          default("false")
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notificacion < ApplicationRecord
  belongs_to :user
end
