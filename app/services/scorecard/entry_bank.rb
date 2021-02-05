class Scorecard
  class EntryBank
    def initialize(day_range, entries)
      @day_range = day_range
      @entries   = entries.order(created_at: :asc)
    end
    attr_reader :entries, :day_range

    def nil_or_zero?                     # I'm not using this anywhere yet but seems like something i may need at some point
      self.nil? || self == 0 || self == ''
    end

    def has_entries?
      entries.present?
    end

    def has_nothing?
      entries.empty?
    end

    def has_beginning_range?
      beginning_range.present?
    end

    def has_end_range?
      end_range.present?
    end

    def has_everything?
      has_beginning_range? && has_end_range?
    end

    def missing_end_range?
      has_beginning_range? && !has_end_range?
    end

    def missing_beginning_range?
      !has_beginning_range? && has_end_range?
    end

    def missing_both_ranges?
      !has_beginning_range? && !has_end_range?
    end

    def beginning_range
      @beginning_range ||= entries.where("#{entry_klass}.created_at <= ?", day_range.creation + day_range.days)
    end

    def end_range
      @end_range ||= entries.where("#{entry_klass}.created_at >= ?", day_range.now - day_range.days)
    end

    private 

    def entry_klass
      @entry_klass ||= entries.first.class.to_s.underscore.pluralize
    end
  end
end
