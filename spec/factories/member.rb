FactoryBot.define do
  factory :member, parent: :user, class: "Member" do
    sequence(:email) { |n| "member#{n}@test.com" }
    gender { "Male" }
  end

  factory :connected_member, parent: :member do
    oauth_token { "blablablah" }
  end
end
