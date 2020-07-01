require "rails_helper"

RSpec.describe "comentario_pois/show", type: :view do
  before(:each) do
    @comentario_poi = assign(:comentario_poi, ComentarioPoi.create!(
                                                poi: nil,
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
