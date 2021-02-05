SMTP_SETTINGS = {
  address: ENV.fetch("SMTP_ADDRESS"),
  authentication: :login,
  domain: ENV.fetch("SMTP_DOMAIN"),
  enable_starttls_auto: true,
  password: ENV.fetch("SMTP_PASSWORD"),
  port: ENV.fetch("SMTP_PORT"),
  user_name: ENV.fetch("SMTP_USERNAME")
}
