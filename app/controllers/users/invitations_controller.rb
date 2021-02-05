class Users::InvitationsController < Devise::InvitationsController
  layout 'static'

  def after_accept_path_for(resource)
    if resource.is_a? Member
      dashboard_path
    else
      patients_path
    end
  end
end