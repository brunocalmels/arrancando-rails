require "rails_helper"

RSpec.describe "comentario_pois/index", type: :view do
  before(:each) do
    assign(:comentario_pois, [
             ComentarioPoi.create!(
               poi: nil,
               user: nil,
               mensaje: "MyText"
             ),
             ComentarioPoi.create!(
               poi: nil,
               user: nil,
               mensaje: "MyText"
             )
           ])
  end

  it "renders a list of comentario_pois" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
