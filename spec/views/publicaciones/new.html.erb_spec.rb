require "rails_helper"

RSpec.describe "publicaciones/new", type: :view do
  before(:each) do
    assign(:publicacion, Publicacion.new(
                           titulo: "MyString",
                           cuerpo: "MyText",
                           puntajes: "",
                           ciudad: nil
                         ))
  end

  it "renders new publicacion form" do
    render

    assert_select "form[action=?][method=?]", publicaciones_path, "post" do
      assert_select "input[name=?]", "publicacion[titulo]"

      assert_select "textarea[name=?]", "publicacion[cuerpo]"

      assert_select "input[name=?]", "publicacion[puntajes]"

      assert_select "input[name=?]", "publicacion[ciudad_id]"
    end
  end
end
