class Scorecard
  class ReportNullEntries < Report
    def to_s
      'Insufficient total entries to accurately measure'
    end

    def to_so   #this is for symptoms that should be measured based on avg per day, not avg per entry
      'no occurrence of this symptom at any time'
    end




    def beginning_range
      'No entries to range'
    end

    def end_range
      'No entries to range'
    end

    def beginning_range_sum
      'No entries to sum'
    end

    def end_range_sum
      'No entries to range'
    end

    def beginning_range_count
      'No entries to count'
    end

    def end_range_count
      'No entries to count'
    end

    def type_start
      'No type start'
    end

    def type_end
      'No type end'
    end
  end
end
