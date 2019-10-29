require "rails_helper"

RSpec.describe PublicacionesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/publicaciones").to route_to("publicaciones#index")
    end

    it "routes to #new" do
      expect(get: "/publicaciones/new").to route_to("publicaciones#new")
    end

    it "routes to #show" do
      expect(get: "/publicaciones/1").to route_to("publicaciones#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/publicaciones/1/edit").to route_to("publicaciones#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/publicaciones").to route_to("publicaciones#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/publicaciones/1").to route_to("publicaciones#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/publicaciones/1").to route_to("publicaciones#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/publicaciones/1").to route_to("publicaciones#destroy", id: "1")
    end
  end
end
