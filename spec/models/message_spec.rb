require "rails_helper"

describe Message do
  describe "relationships" do
    it "should have valid relationships" do
      should belong_to(:clinician)
      should belong_to(:member)
    end
  end

  describe "#unread" do
    it "should return true if the message has not been read" do
      member = create(:member)
      clinician = create(:clinician)
      unread = Message.create(
        member: member,
        clinician: clinician,
        body: "This is a test message",
        read: false
      )
      read = Message.create(
        member: member,
        clinician: clinician,
        body: "This is a test message",
        read: true
      )

      expect(Message.unread).to include(unread)
      expect(Message.unread).not_to include(read)
    end
  end

  describe "#read" do
    it "should return true if the message has been read" do
      member = create(:member)
      clinician = create(:clinician)
      unread = Message.create(
        member: member,
        clinician: clinician,
        body: "This is a test message",
        read: false
      )
      read = Message.create(
        member: member,
        clinician: clinician,
        body: "This is a test message",
        read: true
      )

      expect(Message.read).to include(read)
      expect(Message.read).not_to include(unread)
    end
  end

  describe "#archive" do
    it "should successfully archive a message" do
      member = create(:member)
      clinician = create(:clinician)
      message = Message.create(
        member: member,
        clinician: clinician,
        body: "This is a test message"
      )

      message.archive
      message.reload

      expect(message.archived).to be_truthy
    end
  end

  describe "#unarchive" do
    it "should successfully unarchive a message" do
      member = create(:member)
      clinician = create(:clinician)
      message = Message.create(
        member: member,
        clinician: clinician,
        body: "This is a test message",
        archived: true
      )

      message.unarchive
      message.reload

      expect(message.archived).to be_falsey
    end
  end
end
