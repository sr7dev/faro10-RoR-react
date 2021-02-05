class ExercisesMembership < ApplicationRecord
  belongs_to :exercise
  belongs_to :membership

  has_many :questions, through: :exercise
  has_many :answers, dependent: :destroy

  delegate :longname, :description, :sub_description, :category, to: :exercise

  scope :by_member, -> (member) { joins(:membership).where(memberships: {member_id: member.id}) }
  scope :incomplete, -> { where(status: 'incomplete') }
  scope :complete, -> { where(status: 'complete') }

  def assigned
    created_at.strftime("%D")
  end

  def complete?
    status == 'complete'
  end

  def complete!
    update(status: 'complete', completed: Date.today)
  end
end
