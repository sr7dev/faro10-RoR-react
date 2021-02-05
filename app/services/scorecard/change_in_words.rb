





# This file is no longer in use.  I'm only keeping it here for reference



class Scorecard
  class ChangeInWords
    def initialize(type, entries)
      @type = type
      @entries = entries.where.not(type => nil)
    end
    attr_reader :type, :entries

    def to_s
      return 'is not currently being tracked' unless entries.present?
      return 'has not registered a change' if type_start == type_end

      if type_start.present? && type_end.nan?
        return "has not been tracked in the last #{day_range} days"
      end

      if type_start.nan? && type_end.present?
        return "was not tracked in the first #{day_range} days of treatment"
      end

      "#{change_word} by #{type_progress}%"
    end


    def to_so
      return 'is not currently being tracked' unless entries.present?
      return 'has not registered a change' if type_start == type_end

      # if type_start.present? && type_end.nan?
      #   return "has not been tracked in the last #{day_range} days"
      # end

      if type_start.present? && type_end.has_no_value
        return "has not been tracked in the last #{day_range} days"
      end

      if type_start.has_no_value && type_end.present?
        return "was not tracked in the first #{day_range} days of treatment"
      end

      # if type_start.nan? && type_end.present?
      #   return "was not tracked in the first #{day_range} days of treatment"
      # end

      "#{change_word} by #{type_progress}%"
    end

    def change_word
      type_end > type_start ? 'worsened' : 'improved'
    end

    def type_start
      # if beginning_range.map(&type).present?
        @type_start ||=
        if type == :self_harm
          beginning_range.count / day_range
        elsif uses_entry_count.include?(type)
          beginning_range.map(&type).sum.to_f / beginning_range.count
        else
          beginning_range.map(&type).sum.to_f / day_range
        end
      # else
      #   1
      # end

    end

    def type_end
      @type_end ||=
        if type == :self_harm
          end_range.count / day_range
        elsif uses_entry_count.include?(type)
          end_range.map(&type).sum.to_f / end_range.count
        else
          end_range.map(&type).sum.to_f / day_range
        end
    end

    def type_progress
      (((type_end - type_start) / type_end) * 100).round.abs
    end

    def beginning_range
        @beginning_range ||= entries.where("#{klass}.created_at <= ?", member_creation + day_range.days)
    end

    def end_range
      @end_range ||= entries.where("#{klass}.created_at >= ?", time_now - day_range.days)
    end

    # number of days to take into account for the beginning_range
    # and end_range. will be equal to 1/4 of the entire treatment
    # duration.
    def day_range
      @day_range ||= 
        begin
          total_days = ((time_now.to_i - member_creation.to_i) / 86_400)
          (total_days / 4).round
        end
    end

    def size
      @size ||= entries.size
    end

    def member_creation
      @member ||= entries.first.member.created_at
    rescue NoMethodError => e
      @member ||= entries.first.observer.created_at
    end

    def time_now
      @time_now ||= Time.now
    end

    private

    def uses_entry_count
      %i(zest feeling anxiety hrs_slept appetite concentration initiative energy pessimism social_interaction work_life family_life social_life
       dangerous_behavior delusional hallucination hyperactive energy activity zest)
    end

    def klass
      @klass ||= entries.first.class.to_s.underscore.pluralize
    end


  end
end
