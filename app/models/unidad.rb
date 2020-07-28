# == Schema Information
#
# Table name: unidades
#
#  id         :integer          not null, primary key
#  nombre     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Unidad < ApplicationRecord
end
