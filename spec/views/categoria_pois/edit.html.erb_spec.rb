require "rails_helper"

RSpec.describe "categoria_pois/edit", type: :view do
  before(:each) do
    @categoria_poi = assign(:categoria_poi, CategoriaPoi.create!)
  end

  it "renders the edit categoria_poi form" do
    render

    assert_select "form[action=?][method=?]", categoria_poi_path(@categoria_poi), "post" do
    end
  end
end
