json.array!(@users) do |user|
  json.extract! user, :id, :user_id, :email, :clinician_id, :observers, :race, :gender, :dob, :weight, :zip_code, :nationality, :country, :occupation, :emergency_contact_name, :emergency_contact_num, :diagnosis
  json.url user_url(user, format: :json)
end
