require "rails_helper"

RSpec.describe "ingredientes/edit", type: :view do
  before(:each) do
    @ingrediente = assign(:ingrediente, Ingrediente.create!(
                                          nombre: "MyString"
                                        ))
  end

  it "renders the edit ingrediente form" do
    render

    assert_select "form[action=?][method=?]", ingrediente_path(@ingrediente), "post" do
      assert_select "input[name=?]", "ingrediente[nombre]"
    end
  end
end
