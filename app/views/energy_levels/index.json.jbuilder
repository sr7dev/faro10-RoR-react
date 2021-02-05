json.array!(@energy_levels) do |energy_level|
  json.extract! energy_level, :id, :user_id, :energy_level
  json.url energy_level_url(energy_level, format: :json)
end
