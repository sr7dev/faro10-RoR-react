class SocialsHash
  attr_accessor :data
  attr_reader :start_date, :end_date

  def initialize(member, start_time, end_time)
    @start_time = start_time
    @end_time = end_time
    @start_date = start_time.to_date
    @end_date = end_time.to_date
    @data = member
            .facebook_posts.created_between(start_time, end_time)
            .group_by_day(:created_time, format: "%a, %d %b %Y", series: true)
            .count
    # Actual posts instead of coutn
    # @data = member
    #         .facebook_posts.created_between(start_time, end_time)
    #         .group_by{ |post| post.created_time.strfttime("%a, %d %b %Y")}
    @data = pad_top(@data)
  end

  def pad_top(hash)
    days_back = 15
    new_hash = {}
    loop do
      new_date = (start_date - days_back).strftime("%a, %d %b %Y")
      break if hash.key?(new_date) || hash.empty?
      new_hash = new_hash.merge({new_date => 0})
      days_back -= 1
    end
    new_hash.merge(hash)
  end
end
