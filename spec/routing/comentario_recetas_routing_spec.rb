require "rails_helper"

RSpec.describe ComentarioRecetasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/comentario_recetas").to route_to("comentario_recetas#index")
    end

    it "routes to #new" do
      expect(get: "/comentario_recetas/new").to route_to("comentario_recetas#new")
    end

    it "routes to #show" do
      expect(get: "/comentario_recetas/1").to route_to("comentario_recetas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/comentario_recetas/1/edit").to route_to("comentario_recetas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/comentario_recetas").to route_to("comentario_recetas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/comentario_recetas/1").to route_to("comentario_recetas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/comentario_recetas/1").to route_to("comentario_recetas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/comentario_recetas/1").to route_to("comentario_recetas#destroy", id: "1")
    end
  end
end
