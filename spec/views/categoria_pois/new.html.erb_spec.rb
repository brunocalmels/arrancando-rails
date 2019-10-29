require "rails_helper"

RSpec.describe "categoria_pois/new", type: :view do
  before(:each) do
    assign(:categoria_poi, CategoriaPoi.new)
  end

  it "renders new categoria_poi form" do
    render

    assert_select "form[action=?][method=?]", categoria_pois_path, "post" do
    end
  end
end
