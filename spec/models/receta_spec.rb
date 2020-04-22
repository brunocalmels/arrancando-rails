# == Schema Information
#
# Table name: recetas
#
#  id                  :integer          not null, primary key
#  titulo              :string           not null
#  cuerpo              :text
#  puntajes            :jsonb            default("{}")
#  user_id             :integer          not null
#  categoria_receta_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require "rails_helper"

RSpec.describe Receta, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
