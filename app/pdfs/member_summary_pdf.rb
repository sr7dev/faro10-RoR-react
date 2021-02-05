class MemberSummaryPdf
  include RenderAnywhere

  def initialize(member)
    @member = member
  end

  def to_pdf
    kit = PDFKit.new(as_html)
    kit.to_pdf
  end

  def as_html
    render template: "dashboards/summary",
      layout: "member_summary",
      locals: locals
  end

  private

  attr_reader :member

  def locals
    h = {
      :@my_journal => member.entries.where.not(journal: nil).order(created_at: :desc),
      :@my_entry_total => member.entries.distinct.count(:created_at),
      :@my_self_harm_total => member.entries.count(:self_harm),
      :@my_attended_sessions_total => member.entries.count(:attended_session),
      :@my_observer_entries => member.observer_entries_on_me.count,
      :@my_total_exercise => member.entries.sum('activity'),
      current_user: member
    }

    if member.entries.present?
      h.merge!(:@last_entry => member.entries.order(:created_at).last)
    else
      h.merge!(:@last_entry => 0)
    end
  end

end
