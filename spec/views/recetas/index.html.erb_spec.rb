require "rails_helper"

RSpec.describe "recetas/index", type: :view do
  before(:each) do
    assign(:recetas, [
             Receta.create!(
               titulo: "Título",
               cuerpo: "MyText",
               puntaje: "",
               categoria_receta: nil
             ),
             Receta.create!(
               titulo: "Título",
               cuerpo: "MyText",
               puntaje: "",
               categoria_receta: nil
             )
           ])
  end

  it "renders a list of recetas" do
    render
    assert_select "tr>td", text: "Título".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
