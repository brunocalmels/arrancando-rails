require "rails_helper"

RSpec.describe "seguimientos/new", type: :view do
  before(:each) do
    assign(:seguimiento, Seguimiento.new(
                           seguidor: nil,
                           seguido: nil
                         ))
  end

  it "renders new seguimiento form" do
    render

    assert_select "form[action=?][method=?]", seguimientos_path, "post" do
      assert_select "input[name=?]", "seguimiento[seguidor_id]"

      assert_select "input[name=?]", "seguimiento[seguido_id]"
    end
  end
end
