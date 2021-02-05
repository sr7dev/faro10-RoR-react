require "rails_helper"

describe MedicalCondition do
  describe "relationships" do
    it "should have valid relationships" do
      should have_many(:diagnoses)
      should have_many(:members)
      should have_many(:clinicians)
    end
  end

  describe "#dsm5_code_with_description" do
    it "should return a string with the dsm code and short description" do
      condition = create(:medical_condition, :dsm5_condition)

      expect(
        condition.dsm5_code_with_description
      ).to eq("E66.9 : Obesity, unspecified")
    end
  end

  describe "#icd10_code_with_description" do
    it "should return a string with the dsm code and short description" do
      condition = create(:medical_condition, :icd10_condition)

      expect(condition.icd10_code_with_description).to eq("A00 : Cholera")
    end
  end

  describe "#header_row" do
    it "should return MedicalConditions where is_header_row is false" do
      header = create(:medical_condition, :dsm5_condition)
      not_header = create(:medical_condition, :icd10_condition)

      expect(MedicalCondition.header_row).to include(not_header)
      expect(MedicalCondition.header_row).not_to include(header)
    end
  end
end
