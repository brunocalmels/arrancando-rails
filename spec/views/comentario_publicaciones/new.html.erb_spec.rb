require "rails_helper"

RSpec.describe "comentario_publicaciones/new", type: :view do
  before(:each) do
    assign(:comentario_publicacion, ComentarioPublicacion.new(
                                      publicacion: nil,
                                      user: nil,
                                      mensaje: "MyText"
                                    ))
  end

  it "renders new comentario_publicacion form" do
    render

    assert_select "form[action=?][method=?]", comentario_publicaciones_path, "post" do
      assert_select "input[name=?]", "comentario_publicacion[publicacion_id]"

      assert_select "input[name=?]", "comentario_publicacion[user_id]"

      assert_select "textarea[name=?]", "comentario_publicacion[mensaje]"
    end
  end
end
