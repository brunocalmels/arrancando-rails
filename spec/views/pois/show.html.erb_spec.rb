require "rails_helper"

RSpec.describe "pois/show", type: :view do
  before(:each) do
    @poi = assign(:poi, Poi.create!(
                          titulo: "Titulo",
                          cuerpo: "MyText",
                          lat: 2.5,
                          long: 3.5,
                          puntaje: ""
                        ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(//)
  end
end
