class ScorecardsController < ApplicationController
  def show
    @member    = Member.find(params[:patient_id])

    authorize! :read, @member

    @scorecard = Scorecard.new(@member)
    # identify periods of mania:  Look for 5-day mood average that deviates from monthly mood average
  end
end
