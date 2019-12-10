require "rails_helper"

RSpec.describe "ComentarioRecetas", type: :request do
  describe "GET /comentario_recetas" do
    it "works! (now write some real specs)" do
      get comentario_recetas_path
      expect(response).to have_http_status(200)
    end
  end
end
