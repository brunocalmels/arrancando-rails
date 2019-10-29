require "rails_helper"

RSpec.describe "categoria_pois/index", type: :view do
  before(:each) do
    assign(:categoria_pois, [
             CategoriaPoi.create!,
             CategoriaPoi.create!
           ])
  end

  it "renders a list of categoria_pois" do
    render
  end
end
