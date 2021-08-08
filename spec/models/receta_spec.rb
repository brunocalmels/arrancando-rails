# == Schema Information
#
# Table name: recetas
#
#  id                  :integer          not null, primary key
#  titulo              :string           not null
#  cuerpo              :text
#  puntajes            :jsonb            default("{}")
#  user_id             :integer          not null
#  categoria_receta_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  introduccion        :text
#  ingredientes        :text
#  instrucciones       :text
#  habilitado          :boolean          default("true")
#  duracion            :integer
#  complejidad         :string
#  ingredientes_items  :jsonb            default("[]")
#  vistas              :integer          default("0")
#  saved               :integer          default("{}"), is an Array
#

require "rails_helper"

RSpec.describe Receta, type: :model do
  let(:subject) { FactoryBot.build(:receta) }
  context "with duplicated titulo" do
    it "is not valid" do
      subject.save
      pub2 = subject.dup
      expect(pub2).not_to be_valid
      expect(pub2.errors).to have_key(:titulo)
    end
  end
end
