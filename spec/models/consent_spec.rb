require "rails_helper"

describe Consent do
  describe "validations" do
    it "should hvae valid validations" do
      should validate_presence_of(:membership)
    end
  end

  describe "relationships" do
    it "should have valid relationships" do
      should belong_to(:membership)
      should delegate_method(:member).to(:membership)
      should delegate_method(:clinician).to(:membership)
    end
  end

  describe "#status" do
    it "is active for one year from started_at by default" do
      travel_to DateTime.new(2017, 10, 1) do
        member = create(:member)
        clinician = create(:clinician)
        membership = Membership.create(
          member: member,
          clinician: clinician,
          status: "active",
        )
        consent = create(
          :consent,
          created_at: Date.new(2017, 9, 30),
          ended_at: Date.new(2017, 9, 30) + Consent::DEFAULT_LENGTH,
          membership: membership,
        )

        expect(consent.active?).to be_truthy
      end
    end
  end
end
