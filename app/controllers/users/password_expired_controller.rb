class Users::PasswordExpiredController < Devise::PasswordExpiredController
  layout "static"

  # alias_method :current_clinician, :current_user
  # alias_method :current_member, :current_user
end
