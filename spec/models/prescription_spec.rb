require "rails_helper"

describe Prescription do
  describe "validations" do
    it "should have valid validations" do
      should validate_presence_of(:drug_id)
      should validate_presence_of(:member_id)
      should validate_presence_of(:started)
      should validate_presence_of(:dosage)
      should validate_numericality_of(:dosage)
    end
  end

  describe "relationships" do
    it "should have valid relationships" do
      should belong_to(:member)
      should belong_to(:drug)
      should have_many(:entries_prescriptions)
    end
  end
end
