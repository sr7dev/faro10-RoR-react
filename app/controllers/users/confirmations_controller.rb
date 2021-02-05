class Users::ConfirmationsController < Devise::ConfirmationsController
  layout 'static'
  
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    yield resource if block_given?

    if resource.errors.empty?
      flash[:success] = "Account activated!"
      sign_in resource, scope: resource.type

      # set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      # respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
      flash[:notice] = "Your account is already confirmed. Please login."
      redirect_to new_user_session_path
    end
  end

  protected
    def after_resending_confirmation_instructions_path_for(resource_name)
      super(resource_name)
    end

    def after_confirmation_path_for(resource_name, resource)
      super(resource_name, resource)
    end
end
