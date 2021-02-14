module TestHelper
  def self.authenticate_json(request, user=nil)
    user ||= create_user
    token = JsonWebToken.encode(user_id: user.id)
    request.headers["Authorization"] = "Bearer #{token}"
  end

  def self.authenticate_html(request, admin=nil)
    admin ||= create_admin
    token = JsonWebToken.encode(user_id: admin.id)
    request.headers["Authorization"] = "Bearer #{token}"
  end

  def self.create_user(
    username="mrcook",
    password="someNiftyPass2008",
    email="mrcook@hellskitchen.com"
  )
    FactoryBot.create(:user, username: username, password: password, email: email)
  end

  def self.create_admin(
    username="admin",
    password="someNiftyPass2008",
    email="admin@arrancando.com"
  )
    FactoryBot.create(:user, username: username, password: password, email: email, rol: :admin)
  end
end
