require "rails_helper"

RSpec.describe CategoriaPoisController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/categoria_pois").to route_to("categoria_pois#index")
    end

    it "routes to #new" do
      expect(get: "/categoria_pois/new").to route_to("categoria_pois#new")
    end

    it "routes to #show" do
      expect(get: "/categoria_pois/1").to route_to("categoria_pois#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/categoria_pois/1/edit").to route_to("categoria_pois#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/categoria_pois").to route_to("categoria_pois#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/categoria_pois/1").to route_to("categoria_pois#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/categoria_pois/1").to route_to("categoria_pois#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/categoria_pois/1").to route_to("categoria_pois#destroy", id: "1")
    end
  end
end
