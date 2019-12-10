require "rails_helper"

RSpec.describe "comentario_recetas/show", type: :view do
  before(:each) do
    @comentario_receta = assign(:comentario_receta, ComentarioReceta.create!(
                                                      receta: nil,
                                                      user: nil,
                                                      mensaje: "MyText"
                                                    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
