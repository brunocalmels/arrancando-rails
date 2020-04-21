require "rails_helper"

RSpec.describe IngredientesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/ingredientes").to route_to("ingredientes#index")
    end

    it "routes to #new" do
      expect(get: "/ingredientes/new").to route_to("ingredientes#new")
    end

    it "routes to #show" do
      expect(get: "/ingredientes/1").to route_to("ingredientes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/ingredientes/1/edit").to route_to("ingredientes#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/ingredientes").to route_to("ingredientes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/ingredientes/1").to route_to("ingredientes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/ingredientes/1").to route_to("ingredientes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/ingredientes/1").to route_to("ingredientes#destroy", id: "1")
    end
  end
end
