require "rails_helper"

RSpec.describe "recetas/show", type: :view do
  before(:each) do
    @receta = assign(:receta, Receta.create!(
                                titulo: "Titulo",
                                cuerpo: "MyText",
                                puntaje: "",
                                categoria_receta: nil
                              ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
