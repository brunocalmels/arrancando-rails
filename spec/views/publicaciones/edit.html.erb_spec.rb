require "rails_helper"

RSpec.describe "publicaciones/edit", type: :view do
  before(:each) do
    @publicacion = assign(:publicacion, Publicacion.create!(
                                          titulo: "MyString",
                                          cuerpo: "MyText",
                                          puntajes: "",
                                          ciudad: nil
                                        ))
  end

  it "renders the edit publicacion form" do
    render

    assert_select "form[action=?][method=?]", publicacion_path(@publicacion), "post" do
      assert_select "input[name=?]", "publicacion[titulo]"

      assert_select "textarea[name=?]", "publicacion[cuerpo]"

      assert_select "input[name=?]", "publicacion[puntajes]"

      assert_select "input[name=?]", "publicacion[ciudad_id]"
    end
  end
end
