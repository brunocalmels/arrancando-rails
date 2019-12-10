require "rails_helper"

RSpec.describe "comentario_publicaciones/show", type: :view do
  before(:each) do
    @comentario_publicacion = assign(:comentario_publicacion, ComentarioPublicacion.create!(
                                                                publicacion: nil,
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
