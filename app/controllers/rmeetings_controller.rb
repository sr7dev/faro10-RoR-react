class RmeetingsController < ApplicationController
  def index
    
    @user = current_user
    @meeting = Meeting.find(params[:id])
    @twilio_token = current_user.twilio_token_json()

    @params = {
      meeting: @meeting,
      user: @user,
      userToken: @user.get_token(),
      twilioToken: @twilio_token,
      rootURL: request.protocol + request.host_with_port
    }
    

  end
end
