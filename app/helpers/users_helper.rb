module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.user_id, class: "gravatar")
  end

  def clinician_status_tag(status)
    # content_tag(:span, score)
    # options[:number] ||=  '0-6'
    case status
      when 'active'
        "black"

      when 'pending'
        "yellow"

      else
        "black"
    end
  end

    def message_center_tag(unread)
      case unread
        when unread
          "unread"

        else
          "black"
          
      end
    end

end

