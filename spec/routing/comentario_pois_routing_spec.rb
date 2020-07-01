require "rails_helper"

RSpec.describe ComentarioPoisController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/comentario_pois").to route_to("comentario_pois#index")
    end

    it "routes to #new" do
      expect(get: "/comentario_pois/new").to route_to("comentario_pois#new")
    end

    it "routes to #show" do
      expect(get: "/comentario_pois/1").to route_to("comentario_pois#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/comentario_pois/1/edit").to route_to("comentario_pois#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/comentario_pois").to route_to("comentario_pois#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/comentario_pois/1").to route_to("comentario_pois#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/comentario_pois/1").to route_to("comentario_pois#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/comentario_pois/1").to route_to("comentario_pois#destroy", id: "1")
    end
  end
end
