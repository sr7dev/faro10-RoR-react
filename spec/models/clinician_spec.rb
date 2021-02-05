require "rails_helper"

describe Clinician do
  describe "validations" do
    it "should have valid validations" do
      should validate_presence_of(:clinic_name)
      should validate_presence_of(:clinic_street)
      should validate_presence_of(:clinic_city)
      should validate_presence_of(:clinic_state)
      should validate_presence_of(:clinic_zip)
    end
  end

  describe "relationships" do
    it "should have valid relationships" do
      should belong_to(:group)
      should have_many(:memberships)
      should have_many(:members)
      should have_many(:messages)
    end
  end

  describe "#active_members" do
    it "should return only members with an active membership status" do
      clinician = create(:clinician)
      member = create(:member)
      inactive = create(:member)
      membership = Membership.create(
        member_id: member.id,
        clinician_id: clinician.id,
        status: "active",
      )
      consent = create(
        :consent,
        membership_id: membership.id,
      )
      consent.ended_at = consent.created_at + 1.year
      consent.save
      consent.reload

      expect(clinician.active_members).to eq([member])
      expect(clinician.active_members).not_to include(inactive)
    end
  end

  describe "#pending_members" do
    it "should return only pending members" do
      clinician = create(:clinician)
      member = create(:member)
      inactive = create(:member)
      active = create(:member)
      Membership.create(
        member_id: member.id,
        clinician_id: clinician.id,
        status: "pending",
      )
      Membership.create(
        member_id: active.id,
        clinician_id: clinician.id,
        status: "active",
      )

      expect(clinician.pending_members).to eq([member])
      expect(clinician.pending_members).not_to include(inactive)
      expect(clinician.pending_members).not_to include(active)
    end
  end

  describe "#format_phone" do
    it "should return a valid 10 digit phone number" do
      clinician = create(:clinician, clinic_phone: "1 (555) 555-5555")

      e164 = "+15555555555"

      expect(clinician.clinic_phone).to eq(e164)
    end

    it "should throw and error if number is too long" do
      clinician = create(:clinician, clinic_phone: "+1-555-5555-5555")
      clinician.valid?
      expect(clinician.errors[:clinic_phone]).to include("is invalid")
    end
  end
end
