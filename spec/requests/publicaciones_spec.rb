require "rails_helper"

RSpec.describe "Publicaciones", type: :request do
  describe "GET /publicaciones" do
    it "works! (now write some real specs)" do
      get publicaciones_path
      expect(response).to have_http_status(200)
    end
  end
end
