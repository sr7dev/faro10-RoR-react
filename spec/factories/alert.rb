FactoryBot.define do
  factory :alert do
    alert_body { "There was some alert" }
    alert_type { "alert type" }
  end
end
