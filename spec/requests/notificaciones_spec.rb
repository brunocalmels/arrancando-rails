require "rails_helper"

RSpec.describe "Notificaciones", type: :request do
  describe "GET /notificaciones" do
    it "works! (now write some real specs)" do
      get notificaciones_path
      expect(response).to have_http_status(200)
    end
  end
end
