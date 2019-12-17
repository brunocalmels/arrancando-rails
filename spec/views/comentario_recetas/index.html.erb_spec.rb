require "rails_helper"

RSpec.describe "comentario_recetas/index", type: :view do
  before(:each) do
    assign(:comentario_recetas, [
             ComentarioReceta.create!(
               receta: nil,
               user: nil,
               mensaje: "MyText"
             ),
             ComentarioReceta.create!(
               receta: nil,
               user: nil,
               mensaje: "MyText"
             )
           ])
  end

  it "renders a list of comentario_recetas" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
