require "rails_helper"

RSpec.describe "ingredientes/show", type: :view do
  before(:each) do
    @ingrediente = assign(:ingrediente, Ingrediente.create!(
                                          nombre: "Nombre"
                                        ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nombre/)
  end
end
