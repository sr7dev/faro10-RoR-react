class Scorecard
  class Initializer
    def initialize(scorecard, time)
      @scorecard = scorecard
      @now = time
    end
    attr_reader :scorecard, :now

    delegate :member, :entries, :obs_entries, :instance_variable_set, :instance_variable_get, :banks, :reports, to: :scorecard

    delegate :class_eval, to: Scorecard

    def setup
      initialize_mem_banks
      initialize_obs_banks
      initialize_reports
    end

    def mem_day_range
      @mem_day_range ||= DayRange.new(member, now)
    end

    def obs_day_range
      @obs_day_range ||= DayRange.new(obs_entries.first, now)
    end


    private

    def initialize_mem_banks
      add_bank_vars_and_meths(:mem, entries, MEM_TYPES, mem_day_range)
    end

    def initialize_obs_banks
      add_bank_vars_and_meths(:obs, obs_entries, OBS_TYPES, obs_day_range)
    end

    def add_bank_vars_and_meths(owner, entries, types, range)
      types.each do |type|
        e = entries.where.not(type => nil)
        bank = EntryBank.new(range, e)
        title = "@#{owner}_#{type}_bank"

        instance_variable_set(title, bank)
        banks << bank
        define_methods(title)
      end
    end

    def initialize_reports
      add_rep_vars_and_meths(:mem, MEM_TYPES)
      add_rep_vars_and_meths(:obs, OBS_TYPES)
    end

    def add_rep_vars_and_meths(owner, types)
      types.each do |type|
        bank  = scorecard.send("#{owner}_#{type}_bank")
        title = "@#{owner}_#{type}_report"

        report_klass = if bank.has_nothing?
                         ReportNullEntries
                       elsif bank.has_everything?
                         Report
                       elsif bank.missing_beginning_range? && !bank.missing_end_range?
                         ReportNullBeginning
                       elsif bank.missing_end_range? && !bank.missing_beginning_range?
                         ReportNullEnd
                       elsif bank.missing_both_ranges?
                         ReportNullBoth
                       else
                         raise "Couldn't find a suitable Report class for this case. Member: #{member}. Entry value: #{type}."
                       end

        report = report_klass.new(bank, type)

        instance_variable_set(title, report)
        reports << report
        define_methods(title)
      end
    end

    def define_methods(title)
      class_eval do 
        define_method(title[1..-1]) do 
          instance_variable_get(title)
        end
      end
    end

    def self.get_types(klass)
      klass.columns.map(&:name).reject do |name| 
        ['_id', 'created_at', 'updated_at'].any? do |suffix| 
          name.include?(suffix)
        end
      end
    end

    MEM_TYPES = get_types(Entry)
    OBS_TYPES = get_types(ObserverEntry)
  end
end
