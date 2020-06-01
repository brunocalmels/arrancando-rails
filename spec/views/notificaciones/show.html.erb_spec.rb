require "rails_helper"

RSpec.describe "notificaciones/show", type: :view do
  before(:each) do
    @notificacion = assign(:notificacion, Notificacion.create!(
                                            titulo: "Titulo",
                                            cuerpo: "MyText",
                                            url: "Url",
                                            leido: false,
                                            user: nil
                                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
