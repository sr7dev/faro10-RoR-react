FactoryBot.define do
  factory :clinician, parent: :user, class: "Clinician" do
    sequence(:email) { |n| "clinician#{n+1}@test.com" }
    clinic_phone { "5555555555" }
    clinic_name { Faker::Name.name }
    clinic_street { Faker::Address.street_address }
    clinic_city { Faker::Address.city }
    clinic_state { Faker::Address.state }
    clinic_zip { Faker::Address.zip_code }
  end
end
