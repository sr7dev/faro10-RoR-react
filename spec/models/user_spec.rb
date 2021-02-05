require "rails_helper"

describe User do
  describe "validations" do
    it "should have valid validations" do
      should validate_presence_of(:user_id)
      should validate_length_of(:user_id).is_at_most(50)
      should validate_presence_of(:email)
      should validate_length_of(:email).is_at_most(255)
    end
  end

  describe "relationships" do
    it "should have valid relationships" do
      should have_many(:entries)
      should have_many(:facebook_posts)
    end
  end

  describe "#full_name" do
    it "should return the users id" do
      user = create(:user)

      expect(user.full_name).to eq(user.user_id)
    end
  end
end
