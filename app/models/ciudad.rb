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

class Ciudad < ApplicationRecord
  belongs_to :provincia
end
