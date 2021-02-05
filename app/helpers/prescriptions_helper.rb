module PrescriptionsHelper

  def my_med_consistency_tag(score)
    case score
      when 0..49.99
        "red"

      when 50...74.99
        "lightred"

      when 75..89.99
        "yellow"

      when 90..100
        "green"

      else
        "black"
    end
  end


end
