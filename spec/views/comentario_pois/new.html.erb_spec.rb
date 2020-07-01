require "rails_helper"

RSpec.describe "comentario_pois/new", type: :view do
  before(:each) do
    assign(:comentario_poi, ComentarioPoi.new(
                              poi: nil,
                              user: nil,
                              mensaje: "MyText"
                            ))
  end

  it "renders new comentario_poi form" do
    render

    assert_select "form[action=?][method=?]", comentario_pois_path, "post" do
      assert_select "input[name=?]", "comentario_poi[poi_id]"

      assert_select "input[name=?]", "comentario_poi[user_id]"

      assert_select "textarea[name=?]", "comentario_poi[mensaje]"
    end
  end
end
