require "rails_helper"

RSpec.describe "pois/index", type: :view do
  before(:each) do
    assign(:pois, [
             Poi.create!(
               titulo: "Titulo",
               cuerpo: "MyText",
               lat: 2.5,
               long: 3.5,
               puntaje: ""
             ),
             Poi.create!(
               titulo: "Titulo",
               cuerpo: "MyText",
               lat: 2.5,
               long: 3.5,
               puntaje: ""
             )
           ])
  end

  it "renders a list of pois" do
    render
    assert_select "tr>td", text: "Titulo".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: 2.5.to_s, count: 2
    assert_select "tr>td", text: 3.5.to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
  end
end
