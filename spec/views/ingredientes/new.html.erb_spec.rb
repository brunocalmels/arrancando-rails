require "rails_helper"

RSpec.describe "ingredientes/new", type: :view do
  before(:each) do
    assign(:ingrediente, Ingrediente.new(
                           nombre: "MyString"
                         ))
  end

  it "renders new ingrediente form" do
    render

    assert_select "form[action=?][method=?]", ingredientes_path, "post" do
      assert_select "input[name=?]", "ingrediente[nombre]"
    end
  end
end
