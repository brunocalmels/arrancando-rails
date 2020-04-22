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

class CategoriaReceta < ApplicationRecord
  has_many :recetas, dependent: :nullify

  # Comento porque pueden pisarse de distintas versiones:
  # validates :nombre, presence: true, uniqueness: true

  validates :version, inclusion: { in: [1, 2] }

  scope :v1, lambda {
    where(version: 1)
  }
  scope :v2, lambda {
    where(version: 2)
  }

  def nombre_con_version
    nombre + " (v" + version.to_s + ")"
  end
end
