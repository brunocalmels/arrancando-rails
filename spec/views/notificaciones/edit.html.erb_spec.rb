require "rails_helper"

RSpec.describe "notificaciones/edit", type: :view do
  before(:each) do
    @notificacion = assign(:notificacion, Notificacion.create!(
                                            titulo: "MyString",
                                            cuerpo: "MyText",
                                            url: "MyString",
                                            leido: false,
                                            user: nil
                                          ))
  end

  it "renders the edit notificacion form" do
    render

    assert_select "form[action=?][method=?]", notificacion_path(@notificacion), "post" do
      assert_select "input[name=?]", "notificacion[titulo]"

      assert_select "textarea[name=?]", "notificacion[cuerpo]"

      assert_select "input[name=?]", "notificacion[url]"

      assert_select "input[name=?]", "notificacion[leido]"

      assert_select "input[name=?]", "notificacion[user_id]"
    end
  end
end
