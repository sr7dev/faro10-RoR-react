class GoalCenter
  ENTRIES_TABLE = {
    bronze_target: 30,
    silver_target: 90,
    gold_target: 300,
    platinum_target: 2000
  }

  EXERCISE_TABLE = {
    bronze_target: 200,
    silver_target: 900,
    gold_target: 1600,
    platinum_target: 3600
  }

  ATTENDED_TABLE = {
    bronze_target: 20,
    silver_target: 40,
    gold_target: 60
  }

  def initialize(member)
    @member = member
  end
  attr_reader :member

  delegate :entries, to: :member

  def total_entries
    @total_entries ||= entries.distinct.count(:created_at)
  end

  def entries_goal_progression
    calc(total_entries, entries_target)
  end

  def entries_target
    @entries_target ||= find_target(ENTRIES_TABLE, total_entries, 1000)
  end

  def entries_medal
    case 
    when total_entries < ENTRIES_TABLE[:bronze_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge.png"
    when total_entries < ENTRIES_TABLE[:silver_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/bronze_badge.png"
    when total_entries < ENTRIES_TABLE[:gold_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge_silver_gold.png"
    else
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge_ribbon.png"
    end
  end

  def total_exercise
    @total_exercise ||= entries.sum("activity")
  end

  def exercise_goal_progression
    calc(total_exercise, exercise_target)
  end

  def exercise_target
    @exercise_target ||= find_target(EXERCISE_TABLE, total_exercise, 15000)
  end

  def exercise_medal
    case
    when total_exercise < EXERCISE_TABLE[:bronze_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/badge.png"
    when total_exercise < EXERCISE_TABLE[:silver_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/exercise_bronze_medal.png"
    when total_exercise < EXERCISE_TABLE[:gold_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/exercise_silver_medal.png"
    when total_exercise < EXERCISE_TABLE[:platinum_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/exercise_gold_medal.png"
    when total_exercise > EXERCISE_TABLE[:platinum_target]
      "https://#{ENV.fetch("AWS_S3_BUCKET")}/exercise_platinum_medal.png"
    end
  end

  def total_attended_sessions
    @total_attended_sessions ||= entries.distinct.count(:attended_session)
  end

  def attended_goal_progression
    calc(total_attended_sessions, ATTENDED_TABLE[:gold_target])
  end

  private

  def calc(val, target)
    ((val.to_f / target) * 100).round(1)
  end

  def find_target(table, accomplished, fallback)
    table.values.detect do |val|
      val > accomplished
    end || fallback
  end
end
