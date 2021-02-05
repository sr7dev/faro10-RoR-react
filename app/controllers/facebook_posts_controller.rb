class FacebookPostsController < ApplicationController
  def index
    start_time = params[:start].to_date
    end_time = params[:end].to_date
    @posts = current_user.facebook_posts.created_between(start_time, end_time)

    render json: @posts
  end
end
