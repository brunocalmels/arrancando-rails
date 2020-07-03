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

FactoryBot.define do
  factory :seguimiento do
    seguidor { nil }
    seguido { nil }
  end
end
