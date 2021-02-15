require "rails_helper"

RSpec.describe ContentController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  # let(:valid_attributes) do
  #   skip("Add a hash of attributes valid for your model")
  # end

  # let(:invalid_attributes) do
  #   skip("Add a hash of attributes invalid for your model")
  # end

  let(:user) { TestHelper.create_user }

  # before(:each) do
  #   TestHelper.authenticate_json(@request, user)
  # end

  describe "GET /content" do
    context "for a given user" do
      it "migrates items, likes and connections to another one" do
        TestHelper.authenticate_json(@request, user)
        FactoryBot.create(:publicacion, user: user)
        FactoryBot.create(:receta, user: user)
        FactoryBot.create(:poi, user: user)
        get :index,
            params: { contenidos_home: JSON(%w[publicaciones recetas pois]) },
            format: :json
        expect(response).to be_successful
        resp_body = JSON(response.body)
        expect(resp_body.count).to eq(3)
        expect(resp_body.first["type"]).to eq("pois")
        expect(resp_body.second["type"]).to eq("recetas")
        expect(resp_body.third["type"]).to eq("publicaciones")
      end
    end
  end
end
