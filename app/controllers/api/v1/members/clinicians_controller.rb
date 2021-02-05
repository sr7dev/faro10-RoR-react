class Api::V1::Members::CliniciansController < Api::Controller
  before_action :set_member, only: [:index]

  def index
    render json: @member.clinicians
  end

  private
    def set_member
      @member = Member.find(params[:member_id])
    end
end
