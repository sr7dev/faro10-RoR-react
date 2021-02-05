json.array!(@activity_levels) do |activity_level|
  json.extract! activity_level, :id, :user_id, :activity_level
  json.url activity_level_url(activity_level, format: :json)
end
