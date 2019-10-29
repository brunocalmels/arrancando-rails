require "rails_helper"

RSpec.describe "ciudades/new", type: :view do
  before(:each) do
    assign(:ciudad, Ciudad.new)
  end

  it "renders new ciudad form" do
    render

    assert_select "form[action=?][method=?]", ciudades_path, "post" do
    end
  end
end
