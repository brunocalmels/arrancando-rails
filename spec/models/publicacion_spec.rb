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
    it "is valid" do
      subject.save
      pub2 = subject.dup
      pub2.cuerpo = "Another fancy cuerpo"
      expect(pub2).to be_valid
    end
  end
  context "with duplicated cuerpo" do
    it "is valid" do
      subject.save
      pub2 = subject.dup
      pub2.titulo = "Another fancy titulo"
      expect(pub2).to be_valid
    end
  end
  context "with duplicated titulo and cuerpo" do
    it "is not valid" do
      subject.save
      pub2 = subject.dup
      expect(pub2).not_to be_valid
      expect(pub2.errors).to have_key(:duplicada)
    end
  end
end
