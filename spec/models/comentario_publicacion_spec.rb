# == Schema Information
#
# Table name: comentario_publicaciones
#
#  id             :integer          not null, primary key
#  publicacion_id :integer          not null
#  user_id        :integer          not null
#  mensaje        :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  puntajes       :jsonb            default("{}")
#

require "rails_helper"

RSpec.describe ComentarioPublicacion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
