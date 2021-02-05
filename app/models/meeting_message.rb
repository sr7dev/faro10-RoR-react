class MeetingMessage < ApplicationRecord
  belongs_to :meeting
  belongs_to :channel, optional: :true

end
