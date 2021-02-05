class MeetingInvitation < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :invited, class_name: 'User'
  belongs_to :meeting

  after_create :send_invitation


  def send_invitation
    UserMailer.delay.meeting_invitation(invited)
  end

end
