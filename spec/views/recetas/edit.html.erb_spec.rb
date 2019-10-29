require "rails_helper"

RSpec.describe "recetas/edit", type: :view do
  before(:each) do
    @receta = assign(:receta, Receta.create!(
                                titulo: "MyString",
                                cuerpo: "MyText",
                                puntaje: "",
                                categoria_receta: nil
                              ))
  end

  it "renders the edit receta form" do
    render

    assert_select "form[action=?][method=?]", receta_path(@receta), "post" do
      assert_select "input[name=?]", "receta[titulo]"

      assert_select "textarea[name=?]", "receta[cuerpo]"

      assert_select "input[name=?]", "receta[puntaje]"

      assert_select "input[name=?]", "receta[categoria_receta_id]"
    end
  end
end
