require "rails_helper"

RSpec.describe "recetas/new", type: :view do
  before(:each) do
    assign(:receta, Receta.new(
                      titulo: "MyString",
                      cuerpo: "MyText",
                      puntaje: "",
                      categoria_receta: nil
                    ))
  end

  it "renders new receta form" do
    render

    assert_select "form[action=?][method=?]", recetas_path, "post" do
      assert_select "input[name=?]", "receta[titulo]"

      assert_select "textarea[name=?]", "receta[cuerpo]"

      assert_select "input[name=?]", "receta[puntaje]"

      assert_select "input[name=?]", "receta[categoria_receta_id]"
    end
  end
end
