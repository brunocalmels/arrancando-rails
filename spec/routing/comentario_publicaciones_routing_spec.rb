require "rails_helper"

RSpec.describe ComentarioPublicacionesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/comentario_publicaciones").to route_to("comentario_publicaciones#index")
    end

    it "routes to #new" do
      expect(get: "/comentario_publicaciones/new").to route_to("comentario_publicaciones#new")
    end

    it "routes to #show" do
      expect(get: "/comentario_publicaciones/1").to route_to("comentario_publicaciones#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/comentario_publicaciones/1/edit").to route_to("comentario_publicaciones#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/comentario_publicaciones").to route_to("comentario_publicaciones#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/comentario_publicaciones/1").to route_to("comentario_publicaciones#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/comentario_publicaciones/1").to route_to("comentario_publicaciones#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/comentario_publicaciones/1").to route_to("comentario_publicaciones#destroy", id: "1")
    end
  end
end
