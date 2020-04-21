# == Schema Information
#
# Table name: ingredientes
#
#  id         :integer          not null, primary key
#  nombre     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ingrediente < ApplicationRecord
  has_and_belongs_to_many :recetas,
                          class_name: "Receta",
                          join_table: "ingredientes_recetas"
end
