FactoryBot.define do
  factory :subscription do
    pricing_plan { nil }
    clinician_id { 1 }
  end
end
