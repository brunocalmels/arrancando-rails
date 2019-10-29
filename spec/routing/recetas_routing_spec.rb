require "rails_helper"

RSpec.describe RecetasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/recetas").to route_to("recetas#index")
    end

    it "routes to #new" do
      expect(get: "/recetas/new").to route_to("recetas#new")
    end

    it "routes to #show" do
      expect(get: "/recetas/1").to route_to("recetas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/recetas/1/edit").to route_to("recetas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/recetas").to route_to("recetas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/recetas/1").to route_to("recetas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/recetas/1").to route_to("recetas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/recetas/1").to route_to("recetas#destroy", id: "1")
    end
  end
end
