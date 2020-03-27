# == Schema Information
#
# Table name: provincias
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pais_id    :integer          default("1"), not null
#

require "rails_helper"

RSpec.describe Provincia, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
