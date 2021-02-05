class Scorecard
  def initialize(member)
    @member = member
    @initializer = Initializer.new(self, Time.now)
    @banks   = []
    @reports = []

    @initializer.setup
  end
  attr_reader :initializer, :member, :banks, :reports

  delegate :now, :mem_day_range, :obs_day_range, to: :initializer

  def member_creation
    member.created_at.strftime("%B %d, %Y")
  end

  def entries
    @entries ||= member.entries
  end

  def obs_entries
    @obs_entries ||= member.observer_entries_on_me
  end

  def entries_count
    entries.count
  end

  # def has_no_value(type)
  #   entries.where((type) => [nil, '0'])
  # end

  def session_count
    entries.count('attended_session')
  end

  def self_harm_total
    entries.where.not(self_harm: nil).try(:count) || 0
  end

  def avg(owner, type) # e.g. :social_life/:feeling
    get_report(owner, type) { |r| r.avg }
  end

  def beginning_range(owner, type)
    get_report(owner, type) { |report| report.beginning_range }
  end

  def end_range(owner, type)
    get_report(owner, type) { |report| report.end_range }
  end

  def beginning_range_count(owner, type)
    get_report(owner, type) { |r| r.beginning_range_count }
  end

  def end_range_count(owner, type)
    get_report(owner, type) { |r| r.end_range_count }
  end

  def beginning_range_sum(owner, type)
    get_report(owner, type) { |r| r.beginning_range_sum }
  end

  def end_range_sum(owner, type)
    get_report(owner, type) { |r| r.end_range_sum }
  end

  def type_start(owner, type)
    get_report(owner, type) { |r| r.type_start }
  end
  
  def type_end(owner, type)
    get_report(owner, type) { |r| r.type_end }
  end

  def outcome(owner, type)
    get_report(owner, type) { |r| r.to_s }
  end

  def symptom_outcome(owner, type)
    get_report(owner, type) { |r| r.to_so }
  end

  private

  def get_report(owner, type)
    report = send("#{owner}_#{type}_report")
    yield report
  end
end
