require "rails_helper"

RSpec.describe "ComentarioPublicaciones", type: :request do
  describe "GET /comentario_publicaciones" do
    it "works! (now write some real specs)" do
      get comentario_publicaciones_path
      expect(response).to have_http_status(200)
    end
  end
end
