Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           ENV.fetch("FACEBOOK_KEY"),
           ENV.fetch("FACEBOOK_SECRET"),
           scope: "user_posts"
end
