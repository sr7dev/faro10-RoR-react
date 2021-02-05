class Scorecard
  class ReportNullBoth < Report
    def to_s
      'Insufficient total entries to accurately measure'
    end

    def to_so   #this is for symptoms that should be measured based on avg per day, not avg per entry
      'no recently reported occurrence of this symptom'
    end


    def beginning_range
      'No entries to range'
    end

    def end_range
      'No entries to range'
    end






    def beginning_range_count
      'No entries during this period'
    end

    def end_range_count
      'No entries during this period'
    end

    def beginning_range_sum
      '0'
    end

    def end_range_sum
      '0'
    end

    def type_start
      '0'
    end

    def type_end
      '0'
    end






  end
end
