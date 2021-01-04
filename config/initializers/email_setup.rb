if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "arrancando.herokuapp.com",
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
  }
elsif Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: "smtp.sendgrid.net",
    port: 587,
    domain: "arrancando.herokuapp.com",
    # user_name: ENV["SENDGRID_USERNAME"],
    user_name: "apikey",
    # password: ENV["SENDGRID_PASSWORD"],
    password: ENV["SENDGRID_API_KEY"],
    authentication: "plain",
    enable_starttls_auto: true
  }
end
