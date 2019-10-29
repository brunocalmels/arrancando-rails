require "rails_helper"

RSpec.describe CategoriaRecetasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/categoria_recetas").to route_to("categoria_recetas#index")
    end

    it "routes to #new" do
      expect(get: "/categoria_recetas/new").to route_to("categoria_recetas#new")
    end

    it "routes to #show" do
      expect(get: "/categoria_recetas/1").to route_to("categoria_recetas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/categoria_recetas/1/edit").to route_to("categoria_recetas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/categoria_recetas").to route_to("categoria_recetas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/categoria_recetas/1").to route_to("categoria_recetas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/categoria_recetas/1").to route_to("categoria_recetas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/categoria_recetas/1").to route_to("categoria_recetas#destroy", id: "1")
    end
  end
end
