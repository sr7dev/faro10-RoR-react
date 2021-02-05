module PatientsHelper

  #background and text colors are defined in the conditional_formatting.scss file

  def depression_tag(score)
    # content_tag(:span, score)
    # options[:number] ||=  '0-6'
    case score
             when 3.9..5.0
               "yellow"

             when 5..5.9
               "lightred"

             when 6
               "red"

             else
               "black"
           end
  end

  def hospital_tag(score)
    case score
      when 1
        "lightred"

      when 2..4
        "red"

      when 5..100
        "red"

      else
        "black"
    end
  end

  def suicide_thought_tag(score)
    case score
      when 2..3
        "yellow"

      when 4..9
        "lightred"

      when 10..100
        "red"

      else
        "black"
    end
  end

  def medication_consistency_tag(score)
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
