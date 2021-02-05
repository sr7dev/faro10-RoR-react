unless Rails.env.production?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for development and testing environments"
    task prime: "db:setup" do
      include FactoryBot::Syntax::Methods
      create(:admin)
      c = create(:clinician)

      test_member = create(:member, email: "user1@test.com", password: "password")
      test_clinician = create(:clinician, email: "clinician1@test.com", password: "password")

      test_membership = Membership.create(
          member_id: test_member.id,
          clinician_id: test_clinician.id,
          status: "active"
        )

      test_consent = create(
          :consent,
          membership_id: test_membership.id,
          ended_at: Time.now + 1.year
        )

      members = [
        create(:member),
        create(:member),
        create(:member),
        create(:member),
        create(:member),
      ]

      members.each do |m|
        membership = Membership.create(
          member_id: m.id,
          clinician_id: c.id,
          status: "active"
        )

        consent = create(
          :consent,
          membership_id: membership.id
        )
        consent.reload
        consent.ended_at = consent.created_at + 1.year
        consent.save
      end
    end
  end
end
