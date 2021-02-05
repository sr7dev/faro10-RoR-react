class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :error

  before_action :store_location, unless: :devise_controller?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from "AccessGranted::AccessDenied" do |exception|
    redirect_to root_path, alert: "You don't have permission to access this page."
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:user_id, :email, :password,
                                                              :race, :gender, :clinic_street, :clinic_phone,
                                                              :clinic_city, :clinic_state, :clinic_zip, :country,
                                                              :primary_role, :trial_interested, :diagnosis, :dob,
                                                              :is_clinician, :clinician_type, :clinic_name, :subscription_plan])

      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:user_id,:invitation_token,:password,:password_confirmation,
                                                              :race, :gender, :clinic_street, :clinic_phone,
                                                              :primary_role, :trial_interested, :diagnosis, :dob,
                                                              :clinic_city, :clinic_state, :clinic_zip, :country,
                                                              :is_clinician, :clinician_type, :clinic_name])
    end

  private
    def store_location
      if request.get? and !request.xhr?
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(resource)
      # if session[:previous_url].present?
      #   session[:previous_url]
      if resource.is_a? User
        case resource.type
        when "Member"
          # if resource.sign_in_count == 2
          #   "/auth/facebook"
          # else
            categories_path
          # end
        when "Group"
          groups_path
        when "Clinician"
          patients_path
        else
          root_path
        end
      else
        super
      end
    end
end
