class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :exercises_membership

  def question_text
    question.text
  end
end
