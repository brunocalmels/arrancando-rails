# == Schema Information
#
# Table name: comentario_recetas
#
#  id         :integer          not null, primary key
#  receta_id  :integer          not null
#  user_id    :integer          not null
#  mensaje    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe ComentarioReceta, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
