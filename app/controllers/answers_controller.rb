class AnswersController < ApplicationController
  def create
    if create_answers
      assigned.complete!

      redirect_to assigned_exercises_path, flash: { success: "Successfully submitted #{assigned.longname}!" }
    else
      redirect_to assigned_exercises_path, flash: { error: "Failed to submit #{assigned.longname}. Please contact us if you need assistance." }
    end
  end

  private

  def create_answers
    return true unless answers.present?

    answers.each do |question_id, answer|
      new_ans = assigned.answers.find_or_initialize_by(question_id: question_id)
      new_ans.text = answer
      new_ans.save || (return false)
    end
  end

  def answers
    params['answers']
  end

  def assigned
    @assigned ||= ExercisesMembership.find(params[:assigned_exercise_id])
  end
end
