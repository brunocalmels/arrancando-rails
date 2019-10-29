require "rails_helper"

RSpec.describe "CategoriaRecetas", type: :request do
  describe "GET /categoria_recetas" do
    it "works! (now write some real specs)" do
      get categoria_recetas_path
      expect(response).to have_http_status(200)
    end
  end
end
