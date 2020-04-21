require "rails_helper"

RSpec.describe "Ingredientes", type: :request do
  describe "GET /ingredientes" do
    it "works! (now write some real specs)" do
      get ingredientes_path
      expect(response).to have_http_status(200)
    end
  end
end
