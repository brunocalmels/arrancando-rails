# == Schema Information
#
# Table name: comentario_pois
#
#  id         :integer          not null, primary key
#  poi_id     :integer          not null
#  user_id    :integer          not null
#  mensaje    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe ComentarioPoi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
