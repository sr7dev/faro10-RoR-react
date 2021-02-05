FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@test.com" }
    password { "pass" }

    to_create { |instance| instance.save(validate: false) }
  end
end
