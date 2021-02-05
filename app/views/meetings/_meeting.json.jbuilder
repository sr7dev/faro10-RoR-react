json.extract! meeting, :id, :name, :topic, :start_time, :end_time, :duration, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)
