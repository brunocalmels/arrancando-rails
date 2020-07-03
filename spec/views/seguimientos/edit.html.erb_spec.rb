require "rails_helper"

RSpec.describe "seguimientos/edit", type: :view do
  before(:each) do
    @seguimiento = assign(:seguimiento, Seguimiento.create!(
                                          seguidor: nil,
                                          seguido: nil
                                        ))
  end

  it "renders the edit seguimiento form" do
    render

    assert_select "form[action=?][method=?]", seguimiento_path(@seguimiento), "post" do
      assert_select "input[name=?]", "seguimiento[seguidor_id]"

      assert_select "input[name=?]", "seguimiento[seguido_id]"
    end
  end
end
