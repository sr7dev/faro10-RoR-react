module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Faro10 - Behavioral Health Management and Analytics"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def time_zone_offset(date, context, format_string)
    date.in_time_zone(context).strftime(format_string)
  end

end
