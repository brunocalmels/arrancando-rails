require "rails_helper"

RSpec.describe "ciudades/index", type: :view do
  before(:each) do
    assign(:ciudades, [
             Ciudad.create!,
             Ciudad.create!
           ])
  end

  it "renders a list of ciudades" do
    render
  end
end
