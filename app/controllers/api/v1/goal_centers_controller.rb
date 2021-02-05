class Api::V1::GoalCentersController < Api::Controller
  def show
    gc = GoalCenter.new(current_user)

    # add method to GoalCenter?
    result = {
      entries: {
        goal_progression: gc.entries_goal_progression.round(2),
        target: gc.entries_target,
        medal: gc.entries_medal
      },

      exercise: {
        goal_progression: gc.exercise_goal_progression.round(2),
        target: gc.exercise_target,
        medal: gc.exercise_medal
      },
      # attended_sessions: {
      #   goal_progression: gc.attended_goal_progression,
      #   medal: "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge.png"
      # },

      medication: {
        avg_consistency: current_user.avg_med_consistency,
        target: 100,
        medal: "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge.png"
      },

      sponsored: {
        goal_progression: 10,
        target: 10,
        medal: "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge_sponsored.png"
      }
    }

    respond_with result
  end
end
