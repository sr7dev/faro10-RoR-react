json.array!(@moods) do |mood|
  json.extract! mood, :id, :user_id, :mood
  json.url mood_url(mood, format: :json)
end
