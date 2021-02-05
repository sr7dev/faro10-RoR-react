module ScorecardsHelper
  def impairment_scale(score)
    case score
    when 0..1.0 then "No Issue"
    when 1.1..2 then "Mild"
    when 2.01...4.99 then "Moderate"
    when 5..6 then "Severe"
    else
      "data not provided"
    end
  end

  def suicide_scale(score)
    case score
      when 0..1.0 then "No Issue"
      when 1.1..1.9 then "Mild"
      when 2.00...4.99 then "Moderate"
      when 5..6 then "Severe"
      else
        "data not provided"
    end
  end

  def sheehan_scale(score)
    case score
    when 0..3.7 then "No Issue"
    when 3.8..4.5 then "Mild"
    when 4.51...7.99 then "Moderate"
    when 8..10 then "Severe"
    else
      "data not provided"
   end
  end
end
