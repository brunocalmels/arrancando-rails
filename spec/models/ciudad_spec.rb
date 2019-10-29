# == Schema Information
#
# Table name: ciudades
#
#  id           :integer          not null, primary key
#  nombre       :string           not null
#  provincia_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "rails_helper"

RSpec.describe Ciudad, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
