class SocialsController < ApplicationController
  def index
    @start_date = Date.today.beginning_of_year
    @end_date = Date.today

    @start_time = @start_date.to_time
    @end_time = Time.now

    @facebook = Facebook::HarvestPosts.harvest(current_user)

    @counts = SocialsHash.new(current_user, @start_time, @end_time).data

    @dates  = SocialsCollection.new(@counts.to_a).breakdown

    current_average = @dates.any? ? @dates[@dates.keys[@dates.count - 1]]["current_avg"] : 0

    @socials_props = {
      averagePostCount: current_average,
      dates: @dates.to_json
    }
  end
end
