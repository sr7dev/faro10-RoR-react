class ClinicianSerializer < ActiveModel::Serializer
  attributes :user_id, :clinic_city, :clinic_name, :clinic_phone, :clinic_state, :clinic_street, :clinic_zip
end
