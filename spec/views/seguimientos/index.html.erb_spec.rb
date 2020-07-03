require "rails_helper"

RSpec.describe "seguimientos/index", type: :view do
  before(:each) do
    assign(:seguimientos, [
             Seguimiento.create!(
               seguidor: nil,
               seguido: nil
             ),
             Seguimiento.create!(
               seguidor: nil,
               seguido: nil
             )
           ])
  end

  it "renders a list of seguimientos" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
