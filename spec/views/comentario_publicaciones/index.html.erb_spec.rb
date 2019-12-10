require "rails_helper"

RSpec.describe "comentario_publicaciones/index", type: :view do
  before(:each) do
    assign(:comentario_publicaciones, [
             ComentarioPublicacion.create!(
               publicacion: nil,
               user: nil,
               mensaje: "MyText"
             ),
             ComentarioPublicacion.create!(
               publicacion: nil,
               user: nil,
               mensaje: "MyText"
             )
           ])
  end

  it "renders a list of comentario_publicaciones" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
