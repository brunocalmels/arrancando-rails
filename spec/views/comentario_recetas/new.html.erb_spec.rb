require "rails_helper"

RSpec.describe "comentario_recetas/new", type: :view do
  before(:each) do
    assign(:comentario_receta, ComentarioReceta.new(
                                 receta: nil,
                                 user: nil,
                                 mensaje: "MyText"
                               ))
  end

  it "renders new comentario_receta form" do
    render

    assert_select "form[action=?][method=?]", comentario_recetas_path, "post" do
      assert_select "input[name=?]", "comentario_receta[receta_id]"

      assert_select "input[name=?]", "comentario_receta[user_id]"

      assert_select "textarea[name=?]", "comentario_receta[mensaje]"
    end
  end
end
