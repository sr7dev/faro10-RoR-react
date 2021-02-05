class Scorecard
  class DayRange
    def initialize(obj, now)
      @obj = obj
      @now = now
    end
    attr_reader :now, :obj

    def range
      total_days = ((now.to_i - creation.to_i) / 86_400)
      (total_days / 4).round
    end

    def days
      range.days
    end

    def creation
      obj.created_at
    end
  end
end
