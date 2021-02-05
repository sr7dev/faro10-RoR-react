class TrackedSymptomSerializer < ActiveModel::Serializer
  attributes :id, :patient_id, :patient_name, :symptom_id, :symptom_name

  def symptom_name
    object.symptom.name
  end

  def patient_name
    object.member.user_id
  end
end
