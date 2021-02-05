require "rails_helper"

describe Exercise do
  context "validations" do
    it "should have valid validations" do
      should validate_presence_of(:longname)
      should validate_uniqueness_of(:longname)
      should validate_presence_of(:shortname)
      should validate_uniqueness_of(:shortname)
    end
  end

  context "relationships" do
    it "should have valid relationships" do
      should have_many(:questions)
      should have_many(:assigned_exercises).class_name("ExercisesMembership")
    end
  end

  describe "#parent_questions" do
    it "should return questions that don't have a parent" do
      exercise = create(:exercise)
      q = create(:question, exercise_id: exercise.id)
      q_parent = create(:question, exercise_id: exercise.id, parent_id: q.id)

      expect(exercise.parent_questions).to include(q)
      expect(exercise.parent_questions).not_to include(q_parent)
    end
  end

  describe "#sub_description?" do
    it "should return exercises that have a sub_description" do
      exercise = create(:exercise)
      no_sub = create(
        :exercise,
        sub_description: nil,
        longname: "it's pizzariffic",
        shortname: "ip",
      )

      expect(exercise.sub_description?).to include(exercise)
      expect(exercise.sub_description?).not_to include(no_sub)
    end
  end
end
