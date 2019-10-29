require "rails_helper"

RSpec.describe "categoria_recetas/index", type: :view do
  before(:each) do
    assign(:categoria_recetas, [
             CategoriaReceta.create!,
             CategoriaReceta.create!
           ])
  end

  it "renders a list of categoria_recetas" do
    render
  end
end
