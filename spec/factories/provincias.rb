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

FactoryBot.define do
  factory :provincia do
    nombre { ["Neuquén", "Río Negro", "Mendoza"].sample }
    pais { Pais.any? ? Pais.all.sample : create(:pais) }
  end
end
