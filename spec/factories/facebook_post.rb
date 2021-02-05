FactoryBot.define do
  factory :facebook_post do
    message { Faker::Lorem.sentence(4) }
    created_time { DateTime.now }
    facebook_id { Faker::Crypto.sha1 }
    user { create(:member) }
  end
end
