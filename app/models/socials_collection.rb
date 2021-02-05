class SocialsCollection
  RANGE = 13
  attr_reader :socials

  def initialize(socials)
    @socials = socials
  end

  def breakdown
    result = {}
    @socials.each_with_index do |day, idx|
      count = day[1]
      date = day[0]
      if idx > 13
        average = get_average(idx)
      end

      result[date] = {"number_of_posts" => count}
      if average
        result[date]["current_avg"] = average
      end

      if idx > 14
        yesterday= (Date.parse(date) - 1)

        k = yesterday.strftime("%a, %d %b %Y")
        yesterday_average = result[k]["current_avg"]

        variance = (((yesterday_average - count) / yesterday_average) * 100).round(2)
        result[date]["variance"] = express_variance variance
      end
    end
    result
  end

  private

  def express_variance(degree)
    case
    when degree > 100
      "mild_down"
    when degree < -200
      "severe_up"
    when degree < -100
      "mild_up"
    else
      "average"
    end
  end

  def get_average(idx)
    total = @socials[(idx-RANGE)..(idx)].map {|day| day[1] }.sum


    (total.to_f / (RANGE+1).to_f).round(5)
  end
end
