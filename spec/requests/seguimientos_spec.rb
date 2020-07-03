require "rails_helper"

RSpec.describe "Seguimientos", type: :request do
  describe "GET /seguimientos" do
    it "works! (now write some real specs)" do
      get seguimientos_path
      expect(response).to have_http_status(200)
    end
  end
end
