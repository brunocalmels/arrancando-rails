# == Schema Information
#
# Table name: publicaciones
#
#  id         :integer          not null, primary key
#  titulo     :string           not null
#  cuerpo     :text             not null
#  puntajes   :jsonb            default("{}")
#  user_id    :integer          not null
#  ciudad_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  habilitado :boolean          default("true")
#

require "rails_helper"

RSpec.describe Publicacion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
