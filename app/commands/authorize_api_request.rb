class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers={}, session_auth_token="")
    @headers = headers
    @auth_token = session_auth_token
  end

  def call
    user
  end

  private

  attr_reader :headers, :auth_token

  def user
    puts "DAT: #{decoded_auth_token}"
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, "Invalid token") && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return auth_token unless
      auth_token.nil?
    return headers["Authorization"].split(" ").last if
      headers["Authorization"].present?

    errors.add(:token, "Missing token")
    nil
  end
end
