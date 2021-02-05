FactoryBot.define do
  factory :user do
    user_id { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@test.com" }
    password { "pass" }
    confirmed_at { Time.zone.now } #auto confirm

    after(:build) { |u| u.skip_confirmation_notification! }
    to_create { |instance| instance.save(validate: false) }
  end
end
