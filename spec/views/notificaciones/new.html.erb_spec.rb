require "rails_helper"

RSpec.describe "notificaciones/new", type: :view do
  before(:each) do
    assign(:notificacion, Notificacion.new(
                            titulo: "MyString",
                            cuerpo: "MyText",
                            url: "MyString",
                            leido: false,
                            user: nil
                          ))
  end

  it "renders new notificacion form" do
    render

    assert_select "form[action=?][method=?]", notificaciones_path, "post" do
      assert_select "input[name=?]", "notificacion[titulo]"

      assert_select "textarea[name=?]", "notificacion[cuerpo]"

      assert_select "input[name=?]", "notificacion[url]"

      assert_select "input[name=?]", "notificacion[leido]"

      assert_select "input[name=?]", "notificacion[user_id]"
    end
  end
end
