class ObserveePrescriptionConsistencyChart
  def initialize(observer)
    @observer = observer
  end
  attr_reader :observer

  # used in the web app
  def data
    @data ||= observees.map do |observee|
      process_observee(observee)
    end
  end

  # used in the mobile app
  def full_chart_mobile(weeks)
    observees.each_with_object({observees: []}) do |observee, table|
      data = {user_id: observee.user_id}.merge(process_observee_mobile(observee, weeks.to_i))
      table[:observees].push(data)
    end
  end

  private

  def observees
    observer.observees.with_entries_prescriptions
  end

  def process_observee(observee)
    grouped_eps = observee.entries_prescriptions.group('date(entries_prescriptions.day_taken)')
    { meds_taken: grouped_eps.sum(:times_taken).sort_by(&:first).map{ |k,v| [k.to_date.to_time.to_i*1000, v.to_f]} }
  end

  def process_observee_mobile(observee, weeks)
    grouped_eps = observee.
                  entries_prescriptions.
                  past_weeks(weeks).
                  group('date(entries_prescriptions.day_taken)')

    { meds_taken: grouped_eps.sum(:times_taken).sort_by(&:first).map{ |k,v| [k.to_date.to_time.to_i*1000, v.to_f]} }
  end
end
