FactoryBot.define do
  factory :prescription do
    started { DateTime.new(2017, 6, 1) }
    reminder { 24 }
    reason { "Headaches" }
    dosage { 24 }
    as_needed { true }
    drug

    trait :advil do
      association :drug, factory: [:drug, :advil]
    end

    trait :abilify do
      association :drug, factory: [:drug, :abilify]
    end
  end
end
