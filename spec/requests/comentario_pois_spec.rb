require "rails_helper"

RSpec.describe "ComentarioPois", type: :request do
  describe "GET /comentario_pois" do
    it "works! (now write some real specs)" do
      get comentario_pois_path
      expect(response).to have_http_status(200)
    end
  end
end
