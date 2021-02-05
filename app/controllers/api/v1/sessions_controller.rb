class Api::V1::SessionsController < Api::Controller
  skip_before_action :restrict_access, only: :create

  def create
    if current_user && current_user.valid_password?(params[:session][:password])
      if current_user.confirmed_at.present?
        if current_user.is_a? Member
          token = current_user.set_token
          render json: { success: true, token: token }, status: 200
        else
          msg = "Members only. This mobile app is for Members only, not Clinicians."
          render json: {success: false, message: msg}, status: 401
        end
      else
        msg = "Account not activated. Check your email for the activation link."
        render json: { success: false, message: msg }, status: 401
      end
    else
      render json: { success: false, message: "Invalid email/password combination"}, status: 401
    end
  end

  def destroy
    current_user.set_token
    render json: { success: true }
  end
end
