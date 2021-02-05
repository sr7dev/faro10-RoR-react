class Question < ApplicationRecord
  belongs_to :exercise
  belongs_to :parent, class_name: 'Question', optional: true
  has_many :children, class_name: 'Question', foreign_key: :parent_id, dependent: :destroy
  # some questions are multiple choice
  has_many :answer_choices, dependent: :destroy 

  validates_presence_of :exercise_id
  validates_presence_of :text

  default_scope { order(created_at: :asc) }
  scope :answerable, -> { where(answerable: true) }
  scope :header, -> { where(answerable: false) }

  def child?
    parent_id.present?
  end

  def parent?
    parent_id.nil?
  end

  def has_comment?
    comment.present?
  end

  def multiple_choice?
    style == 'multiple_choice'
  end
end
