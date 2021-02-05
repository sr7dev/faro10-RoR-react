class Exercise < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :assigned_exercises, class_name: 'ExercisesMembership'

  validates_uniqueness_of :longname, :shortname
  validates_presence_of :longname, :shortname

  def parent_questions
    questions.where(parent_id: nil)
  end

  def children
    questions.where(parent_id: self)
  end

  def sub_description?
    Exercise.where.not(sub_description: nil)
  end

end
