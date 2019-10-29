require "rails_helper"

RSpec.describe "Ciudades", type: :request do
  describe "GET /ciudades" do
    it "works! (now write some real specs)" do
      get ciudades_path
      expect(response).to have_http_status(200)
    end
  end
end
