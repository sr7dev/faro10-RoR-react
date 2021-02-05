class Api::V1::PasswordsController < Api::Controller
  skip_before_action :restrict_access, only: :create

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.send_reset_password_instructions
      render json: {success: true, message: "Please check your email to reset  your password."}
    else
      render json: {success: false, message: "Invalid email, try again."}
    end
  end
end
