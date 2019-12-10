require "rails_helper"

RSpec.describe "comentario_recetas/edit", type: :view do
  before(:each) do
    @comentario_receta = assign(:comentario_receta, ComentarioReceta.create!(
                                                      receta: nil,
                                                      user: nil,
                                                      mensaje: "MyText"
                                                    ))
  end

  it "renders the edit comentario_receta form" do
    render

    assert_select "form[action=?][method=?]", comentario_receta_path(@comentario_receta), "post" do
      assert_select "input[name=?]", "comentario_receta[receta_id]"

      assert_select "input[name=?]", "comentario_receta[user_id]"

      assert_select "textarea[name=?]", "comentario_receta[mensaje]"
    end
  end
end
