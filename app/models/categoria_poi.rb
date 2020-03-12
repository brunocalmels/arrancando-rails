# == Schema Information
#
# Table name: categoria_pois
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CategoriaPoi < ApplicationRecord
  has_many :pois
  validates :nombre, presence: true, uniqueness: true
end
