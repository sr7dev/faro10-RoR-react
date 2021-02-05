class Api::V1::UsersController < Api::Controller
  before_action :set_user, only: [:show, :update]
  skip_before_action :restrict_access, only: :create
  before_action :set_twilio_user, only: [:twilio_token]

  # GET /user
  def show
    authorize! :read, @user
    render json: @user, serializer: UserSerializer
  end

  #
  # # GET /users/new_clinician
  # def team
  #   @user = current_user
  #   @observations = @user.observations_on_me
  #   @clinicians = current_user.clinicians
  #   @new_user = User.new
  # end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: {success: true, id: @user.id, message: "Please check your email to activate your account."}
    else
      render json: {success: false, errors: @user.errors}
    end
  end

  # PATCH/PUT /user
  def update
    if @user.update_attributes(user_params)
      authorize! :update, @user
      render json: @user, serializer: UserSerializer
    else
      render json: {success: false, errors: @user.errors}
    end
  end

  # GET /users/timezones
  def time_zones
    time_zones = {time_zones: ActiveSupport::TimeZone.all.map(&:name)}
    render json: time_zones.to_json
  end

  # GET /users/:user_id/twilio_token
  def twilio_token
    twilio_token = @user.twilio_token
    render json: {token: twilio_token.to_jwt, expiration: twilio_token.valid_until}.to_json
  end

  private
    def set_user
      @user = current_user
    end

    def set_twilio_user
      @user = User.find(params[:user_id])
    end

    def user_params
      params.require(:user).permit(:user_id, :email, :password, :observer_id, :clinician_id, :time_zone, :race, :gender, :trial_interested, :dob, :weight, :zip_code, :nationality, :country, :occupation, :emergency_contact_name, :emergency_contact_num, :diagnosis, :primary_role).merge(type: "Member")
    end
end
