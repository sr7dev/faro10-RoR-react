ActiveAdmin.register Symptom do

  filter :patient_id_not_null, as: :boolean, label: "Patient Created"
  filter :patient_id_null, as: :boolean, label: "Default"

  permit_params :name

end
