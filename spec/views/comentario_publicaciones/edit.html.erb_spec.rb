require "rails_helper"

RSpec.describe "comentario_publicaciones/edit", type: :view do
  before(:each) do
    @comentario_publicacion = assign(:comentario_publicacion, ComentarioPublicacion.create!(
                                                                publicacion: nil,
                                                                user: nil,
                                                                mensaje: "MyText"
                                                              ))
  end

  it "renders the edit comentario_publicacion form" do
    render

    assert_select "form[action=?][method=?]", comentario_publicacion_path(@comentario_publicacion), "post" do
      assert_select "input[name=?]", "comentario_publicacion[publicacion_id]"

      assert_select "input[name=?]", "comentario_publicacion[user_id]"

      assert_select "textarea[name=?]", "comentario_publicacion[mensaje]"
    end
  end
end
