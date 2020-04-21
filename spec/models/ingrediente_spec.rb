# == Schema Information
#
# Table name: ingredientes
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe Ingrediente, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
