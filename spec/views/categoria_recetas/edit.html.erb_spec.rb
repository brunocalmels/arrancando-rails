require "rails_helper"

RSpec.describe "categoria_recetas/edit", type: :view do
  before(:each) do
    @categoria_receta = assign(:categoria_receta, CategoriaReceta.create!)
  end

  it "renders the edit categoria_receta form" do
    render

    assert_select "form[action=?][method=?]", categoria_receta_path(@categoria_receta), "post" do
    end
  end
end
