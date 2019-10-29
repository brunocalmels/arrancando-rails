require "rails_helper"

RSpec.describe "categoria_pois/show", type: :view do
  before(:each) do
    @categoria_poi = assign(:categoria_poi, CategoriaPoi.create!)
  end

  it "renders attributes in <p>" do
    render
  end
end
