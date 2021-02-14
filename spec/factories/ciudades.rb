# == Schema Information
#
# Table name: ciudades
#
#  id                        :integer          not null, primary key
#  nombre                    :string           not null
#  provincia_id              :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  populada                  :boolean          default("false")
#  fecha_populacion          :datetime
#  version_script_populacion :string
#  rubros                    :string           default("{}"), is an Array
#

FactoryBot.define do
  factory :ciudad do
    nombre { "Los Recaldes" }
    provincia { Provincia.any? ? Provincia.sample : create(:provincia) }
  end
end
