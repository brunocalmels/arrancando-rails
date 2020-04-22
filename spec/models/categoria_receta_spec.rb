# == Schema Information
#
# Table name: categoria_recetas
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  version    :integer          default("1"), not null
#

require "rails_helper"

RSpec.describe CategoriaReceta, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
