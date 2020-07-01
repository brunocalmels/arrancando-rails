require "rails_helper"

RSpec.describe "comentario_pois/edit", type: :view do
  before(:each) do
    @comentario_poi = assign(:comentario_poi, ComentarioPoi.create!(
                                                poi: nil,
                                                user: nil,
                                                mensaje: "MyText"
                                              ))
  end

  it "renders the edit comentario_poi form" do
    render

    assert_select "form[action=?][method=?]", comentario_poi_path(@comentario_poi), "post" do
      assert_select "input[name=?]", "comentario_poi[poi_id]"

      assert_select "input[name=?]", "comentario_poi[user_id]"

      assert_select "textarea[name=?]", "comentario_poi[mensaje]"
    end
  end
end
