require "rails_helper"

describe Symptom do
  describe "relationships" do
    it "should have valid relationships" do
      should have_many(:entries)
      should have_many(:entries_symptoms)
      should have_many(:members)
      should have_many(:tracked_symptoms)
      should have_many(:tracked_by)
    end
  end
end
