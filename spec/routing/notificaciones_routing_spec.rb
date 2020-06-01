require "rails_helper"

RSpec.describe NotificacionesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/notificaciones").to route_to("notificaciones#index")
    end

    it "routes to #new" do
      expect(get: "/notificaciones/new").to route_to("notificaciones#new")
    end

    it "routes to #show" do
      expect(get: "/notificaciones/1").to route_to("notificaciones#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/notificaciones/1/edit").to route_to("notificaciones#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/notificaciones").to route_to("notificaciones#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/notificaciones/1").to route_to("notificaciones#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/notificaciones/1").to route_to("notificaciones#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/notificaciones/1").to route_to("notificaciones#destroy", id: "1")
    end
  end
end
