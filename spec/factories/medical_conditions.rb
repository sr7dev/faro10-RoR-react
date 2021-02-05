FactoryBot.define do
  factory :medical_condition do
    trait :icd10_condition do
      order_number { "1" }
      icd10_code { "A00" }
      is_not_header { false }
      short_description { "Cholera" }
      long_description { "Cholera" }
      dsm_code { nil }
      is_dsm { false }
    end

    trait :dsm5_condition do
      order_number { "4480" }
      icd10_code { "E669" }
      is_not_header { true }
      short_description { "Obesity, unspecified" }
      long_description { "Obesity, unspecified" }
      dsm_code { "E66.9" }
      is_dsm { true }
    end
  end
end
