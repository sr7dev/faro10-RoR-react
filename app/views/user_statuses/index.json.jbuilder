json.array!(@user_statuses) do |user_status|
  json.extract! user_status, :id, :user_id, :journal_entry, :anx_attack, :have_headache
  json.url user_status_url(user_status, format: :json)
end
