require "rails_helper"

RSpec.describe "CategoriaPois", type: :request do
  describe "GET /categoria_pois" do
    it "works! (now write some real specs)" do
      get categoria_pois_path
      expect(response).to have_http_status(200)
    end
  end
end
