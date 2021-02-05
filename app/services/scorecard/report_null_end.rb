class Scorecard
  class ReportNullEnd < Report
    def to_s
      'Not enough recent entries to accurately measure'
    end

    def to_so   #this is for symptoms that should be measured based on avg per day, not avg per entry
      'no recently reported occurrence of symptom'
    end


    def end_range_count
      'No entries during this period'
    end

    def end_range_sum
      '0'
    end


    def type_end
      '0'
    end


    def end_range
      'No entries in this range'
    end

  end
end
