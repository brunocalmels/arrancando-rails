require "rails_helper"

RSpec.describe "notificaciones/index", type: :view do
  before(:each) do
    assign(:notificaciones, [
             Notificacion.create!(
               titulo: "Titulo",
               cuerpo: "MyText",
               url: "Url",
               leido: false,
               user: nil
             ),
             Notificacion.create!(
               titulo: "Titulo",
               cuerpo: "MyText",
               url: "Url",
               leido: false,
               user: nil
             )
           ])
  end

  it "renders a list of notificaciones" do
    render
    assert_select "tr>td", text: "Titulo".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Url".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
