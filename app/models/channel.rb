class Channel < ApplicationRecord
  belongs_to :meeting
  belongs_to :member, foreign_key: :user_id
  has_many :meeting_messages
  has_many :meeting_users, through: :meeting

  has_many :users, through: :meeting_users
  has_many :channel_assets, dependent: :destroy, inverse_of: :channel

  accepts_nested_attributes_for :channel_assets, allow_destroy: true,
                                reject_if: ->(attrs) { attrs[:source].blank? }



  def channel_follower?
    Channel.meeting.meeting_users.where(user: current_user)
  end

  def self.is_partner?
    where(is_partner: true)
  end



end

