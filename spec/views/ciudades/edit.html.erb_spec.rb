require "rails_helper"

RSpec.describe "ciudades/edit", type: :view do
  before(:each) do
    @ciudad = assign(:ciudad, Ciudad.create!)
  end

  it "renders the edit ciudad form" do
    render

    assert_select "form[action=?][method=?]", ciudad_path(@ciudad), "post" do
    end
  end
end
