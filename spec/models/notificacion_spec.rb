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

require "rails_helper"

RSpec.describe Notificacion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
