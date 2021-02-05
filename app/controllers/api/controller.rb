class Api::Controller < ActionController::Base
  before_action :restrict_access

  respond_to :json

  rescue_from "AccessGranted::AccessDenied" do |exception|
    render status: 403, json: { errors: "Not authorized to access resource" }
  end

  private
    def restrict_access
      user = User.find_by_email(params[:session][:email].downcase)
      unless user && user.check_token(params[:session][:token])
        head :unauthorized
      end
    end

    def current_user
      user = User.find_by(email: params[:session][:email].downcase)
    end
end
