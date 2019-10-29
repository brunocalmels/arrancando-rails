require "rails_helper"

RSpec.describe "categoria_recetas/new", type: :view do
  before(:each) do
    assign(:categoria_receta, CategoriaReceta.new)
  end

  it "renders new categoria_receta form" do
    render

    assert_select "form[action=?][method=?]", categoria_recetas_path, "post" do
    end
  end
end
