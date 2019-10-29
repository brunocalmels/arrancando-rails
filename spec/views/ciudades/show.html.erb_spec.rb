require "rails_helper"

RSpec.describe "ciudades/show", type: :view do
  before(:each) do
    @ciudad = assign(:ciudad, Ciudad.create!)
  end

  it "renders attributes in <p>" do
    render
  end
end
