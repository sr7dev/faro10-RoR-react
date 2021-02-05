class Api::V1::AlertsController < ApplicationController


  def index

  end

  def create
    authorize! :create, Alert
    @alert = Alert.new(alert_params)
    @alert.member_id = current_user.id
    @alert.save

    # else
    #   render status: 400, json: { errors: @alerts.errors.full_messages }
    # end
  end


  private

  def alert_params
    params.require(:alert).permit(:id, :member_id, :alert_body)
  end

end