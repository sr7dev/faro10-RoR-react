class FacebookPost < ApplicationRecord
  belongs_to :user

  scope :created_between, lambda {|start_time, end_time| where("created_time >= ? AND created_time <= ?", start_time, end_time )}
end
