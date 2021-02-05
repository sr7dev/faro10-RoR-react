json.array!(@entries) do |entry|
  json.extract! entry, :id, :user_id, :feeling, :emotion, :energy, :activity, :anxiety, :headache, :journal
  json.url entry_url(entry, format: :json)
end
