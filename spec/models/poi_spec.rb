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
#  ciudad_id        :integer          default("1"), not null
#  whatsapp         :integer
#  vistas           :integer          default("0")
#  saved            :integer          default("{}"), is an Array
#

require "rails_helper"

RSpec.describe Poi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
