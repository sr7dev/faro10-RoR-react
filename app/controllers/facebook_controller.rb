class FacebookController < ApplicationController
  def create
    auth = env["omniauth.auth"]
    current_user.add_facebook_authorization(auth)
    redirect_to socials_path
  end

  def index
    Facebook::HarvestPosts.harvest(current_user) unless current_user.connected_to_facebook?
    redirect_to socials_path
  end
end
