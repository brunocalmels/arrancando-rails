require "rails_helper"

RSpec.describe "ingredientes/index", type: :view do
  before(:each) do
    assign(:ingredientes, [
             Ingrediente.create!(
               nombre: "Nombre"
             ),
             Ingrediente.create!(
               nombre: "Nombre"
             )
           ])
  end

  it "renders a list of ingredientes" do
    render
    assert_select "tr>td", text: "Nombre".to_s, count: 2
  end
end
