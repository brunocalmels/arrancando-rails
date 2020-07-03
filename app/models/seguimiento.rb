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

class Seguimiento < ApplicationRecord
  belongs_to :seguidor, class_name: "User", required: true
  belongs_to :seguido, class_name: "User", required: true
end
