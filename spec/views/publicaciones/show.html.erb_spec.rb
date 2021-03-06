require "rails_helper"

RSpec.describe "publicaciones/show", type: :view do
  before(:each) do
    @publicacion = assign(:publicacion, Publicacion.create!(
                                          titulo: "Título",
                                          cuerpo: "MyText",
                                          puntajes: "",
                                          ciudad: nil
                                        ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Título/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
