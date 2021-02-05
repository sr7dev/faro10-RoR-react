FactoryBot.define do
  factory :pricing_plan do
    name { "MyString" }
    stripe_id { "MyString" }
    interval { "MyString" }
    amount { 1 }
  end
end
