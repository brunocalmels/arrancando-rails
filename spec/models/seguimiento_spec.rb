# == Schema Information
#
# Table name: seguimientos
#
#  id          :integer          not null, primary key
#  seguidor_id :integer          not null
#  seguido_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Seguimiento, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
