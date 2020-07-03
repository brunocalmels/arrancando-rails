require "rails_helper"

RSpec.describe SeguimientosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/seguimientos").to route_to("seguimientos#index")
    end

    it "routes to #new" do
      expect(get: "/seguimientos/new").to route_to("seguimientos#new")
    end

    it "routes to #show" do
      expect(get: "/seguimientos/1").to route_to("seguimientos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/seguimientos/1/edit").to route_to("seguimientos#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/seguimientos").to route_to("seguimientos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/seguimientos/1").to route_to("seguimientos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/seguimientos/1").to route_to("seguimientos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/seguimientos/1").to route_to("seguimientos#destroy", id: "1")
    end
  end
end
