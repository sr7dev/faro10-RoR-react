json.array!(@prescriptions) do |prescription|
  json.extract! prescription, :id, :user_id, :prescription1_id, :dosage1, :prescription2_id, :dosage2, :prescription3_id, :dosage3
  json.url prescription_url(prescription, format: :json)
end
