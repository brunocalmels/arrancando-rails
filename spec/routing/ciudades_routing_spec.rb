require "rails_helper"

RSpec.describe CiudadesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/ciudades").to route_to("ciudades#index")
    end

    it "routes to #new" do
      expect(get: "/ciudades/new").to route_to("ciudades#new")
    end

    it "routes to #show" do
      expect(get: "/ciudades/1").to route_to("ciudades#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/ciudades/1/edit").to route_to("ciudades#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/ciudades").to route_to("ciudades#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/ciudades/1").to route_to("ciudades#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/ciudades/1").to route_to("ciudades#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/ciudades/1").to route_to("ciudades#destroy", id: "1")
    end
  end
end
