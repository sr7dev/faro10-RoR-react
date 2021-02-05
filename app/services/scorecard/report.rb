class Scorecard
  class Report
    def initialize(bank, type)
      @type = type.to_sym
      @bank = bank
    end
    attr_reader :bank, :type

    delegate :beginning_range, :end_range, :day_range, :entries, to: :bank

    def to_s
      "#{change_word} by #{type_progress}%"
    end

    def to_so
      "#{change_word} by #{type_progress}"
    end

    def change_word
      type_end > type_start ? 'worsened' : 'improved'
    end

    def type_start
      @type_start ||=
        if type == :self_harm
          beginning_range_count / day_range.range.to_f
        elsif uses_entry_count.include?(type)
          beginning_range_sum / beginning_range_count.to_f
        else
          # beginning_range_sum / day_range.range.to_f
          beginning_range_sum
        end.round(3)
    end

    def type_end
      @type_end ||=
        if type == :self_harm
          end_range_count / day_range.range.to_f
        elsif uses_entry_count.include?(type)
          end_range_sum / end_range_count.to_f
        else

          # end_range_sum / day_range.range.to_f
          end_range_sum
        end.round(3)
    end

    def type_progress
      if uses_entry_count.include?(type)
        (type_end > 0) ? (((type_end - type_start) / type_end) * 100).round.abs : 0
      elsif type == :self_harm
        return "symptom change from #{beginning_range_count} to #{end_range_count} occurrences "
      else
        return "symptom change from #{beginning_range_sum.round(0)} to #{end_range_sum.round(0)} occurrences "

      end
    end

    def beginning_range_sum
      beginning_range.sum(type).to_f
    end

    def end_range_sum
      end_range.sum(type).to_f
    end

    def beginning_range_count
      beginning_range.count
    end

    def end_range_count
      end_range.count
    end

    def avg
      entries.average(type)
    end

    private

    def uses_entry_count
      %i(zest feeling anxiety hrs_slept appetite concentration initiative energy pessimism social_interaction work_life family_life social_life
       dangerous_behavior delusional hallucination hyperactive energy activity zest)
    end
  end
end
