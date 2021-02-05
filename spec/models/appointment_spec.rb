require "rails_helper"

describe Appointment do
  describe "validations" do
    it "should have valid validations" do
      should validate_presence_of(:created_by)
      should validate_presence_of(:duration)
      should validate_presence_of(:start_time)
      should validate_presence_of(:title)
    end
  end

  describe "relationships" do
    it "should have valid relationships" do
      should belong_to(:member)
    end
  end

  describe "#set_end_time" do
    it "should return the start time plus the duration in minutes" do
      member = create(:member)
      clinician = create(:clinician)
      apt = create(
        :appointment,
        member: member,
        created_by: clinician.id,
        created_at: DateTime.new(2017, 10, 1, 11),
        start_time: DateTime.new(2017, 10, 1, 11),
      )

      expect(apt.end_time).to eq(DateTime.new(2017, 10, 1, 11, 30))
    end
  end
end
