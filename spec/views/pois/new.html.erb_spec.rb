require "rails_helper"

RSpec.describe "pois/new", type: :view do
  before(:each) do
    assign(:poi, Poi.new(
                   titulo: "MyString",
                   cuerpo: "MyText",
                   lat: 1.5,
                   long: 1.5,
                   puntaje: ""
                 ))
  end

  it "renders new poi form" do
    render

    assert_select "form[action=?][method=?]", pois_path, "post" do
      assert_select "input[name=?]", "poi[titulo]"

      assert_select "textarea[name=?]", "poi[cuerpo]"

      assert_select "input[name=?]", "poi[lat]"

      assert_select "input[name=?]", "poi[long]"

      assert_select "input[name=?]", "poi[puntaje]"
    end
  end
end
