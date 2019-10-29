require "rails_helper"

RSpec.describe "categoria_recetas/show", type: :view do
  before(:each) do
    @categoria_receta = assign(:categoria_receta, CategoriaReceta.create!)
  end

  it "renders attributes in <p>" do
    render
  end
end
