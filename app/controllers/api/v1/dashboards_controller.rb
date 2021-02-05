class Api::V1::DashboardsController < Api::Controller
  def show
    entries = current_user.entries
    result = {}

    result[:my_entry_total] = entries.count(:created_at)

    # result[:my_self_harm_total] = entries.count(:self_harm)
    # result[:my_attended_sessions_total] = entries.count(:attended_session)

    result[:my_self_harm_total] = entries.where.not(self_harm: [nil, '']).count(:self_harm)
    result[:my_attended_sessions_total] = entries.where.not(attended_session: [nil, '']).count(:attended_session)

    if current_user.entries.present?
      result[:last_entry] = entries.order('created_at ASC').last.created_at
    else
      result[:last_entry] = 0
    end

    respond_with result.to_json
  end
end
