class MembershipSerializer < ActiveModel::Serializer
  attributes :clinician_id, :clinic_name, :status, :user_name, :id

  def clinic_name
    object.clinician.clinic_name
  end

  def user_name
    object.clinician.user_id
  end
end
