# == Schema Information
#
# Table name: publicaciones
#
#  id                       :integer          not null, primary key
#  titulo                   :string           not null
#  cuerpo                   :text             not null
#  puntajes                 :jsonb            default("{}")
#  user_id                  :integer          not null
#  ciudad_id                :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  habilitado               :boolean          default("true")
#  categoria_publicacion_id :integer          default("1"), not null
#  vistas                   :integer          default("0")
#  saved                    :integer          default("{}"), is an Array
#

require "rails_helper"

RSpec.describe Publicacion, type: :model do
  let(:subject) { FactoryBot.build(:publicacion) }
  context "with duplicated titulo" do
    it "is not valid" do
      subject.save
      pub2 = subject.dup
      expect(pub2).not_to be_valid
      expect(pub2.errors).to have_key(:titulo)
    end
  end
end
