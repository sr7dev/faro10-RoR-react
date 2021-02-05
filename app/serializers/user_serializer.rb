class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :email, :race, :gender, :dob, :weight, :zip_code, :nationality, :time_zone,
             :country, :occupation, :emergency_contact_name, :emergency_contact_num, :diagnosis, :clinician_id, :primary_role, :trial_interested, :about

end