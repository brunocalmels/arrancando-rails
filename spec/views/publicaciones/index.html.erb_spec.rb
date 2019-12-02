require "rails_helper"

RSpec.describe "publicaciones/index", type: :view do
  before(:each) do
    assign(:publicaciones, [
             Publicacion.create!(
               titulo: "Título",
               cuerpo: "MyText",
               puntajes: "",
               ciudad: nil
             ),
             Publicacion.create!(
               titulo: "Título",
               cuerpo: "MyText",
               puntajes: "",
               ciudad: nil
             )
           ])
  end

  it "renders a list of publicaciones" do
    render
    assert_select "tr>td", text: "Título".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
