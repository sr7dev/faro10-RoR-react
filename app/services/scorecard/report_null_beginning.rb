class Scorecard
  class ReportNullBeginning < Report
    def to_s   #this is for health measures that should be measured based on avg per entry
      'Insufficient entries during initial range to accurately measure'
    end

    def to_so   #this is for symptoms that should be measured based on avg per day, not avg per entry
      'This symptom has emerged that was not initially present'
    end

    def beginning_range
      'No beginning range'
    end



    def beginning_range_count
      'No entries during this period'
    end

    def beginning_range_sum
      '0'
    end

    def type_start
      '0'
    end





  end
end
