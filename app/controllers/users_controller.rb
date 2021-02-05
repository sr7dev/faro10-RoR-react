class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def tips

  end

  def exercises
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end

  # GET /users/new
  def new
    authorize! :create, User
    @user = User.new
  end

  def team
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
  end

  def invite_clinician
    begin
      current_user.send_clinician_invitation(params[:invitation][:email])
      flash[:success] = "Your Clinician invitation has been sent"

    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:error] =   "MeetingInvitation failed to send"
    end
    redirect_back fallback_location: root_path
  end

  def invite_member
    member = User.invite!({email: params[:invitation][:email]}, current_user) do |member|
      member.skip_invitation = true
      flash[:error] =  "This user already has an account"
    end

    invitation_url = accept_user_invitation_url(invitation_token: member.raw_invitation_token)

    if RequestMembershipService.new(clinician: current_user, member: member, invitation_url: invitation_url).perform
      flash[:success] =  "Your invitation has been sent"
    else
      flash[:error] =  "MeetingInvitation failed to send"
    end
    redirect_back fallback_location: root_path
  end

  def invite_observer
    if current_user.send_observer_invitation(params[:invitation][:email])
      flash[:success] =  "Your invitation has been sent"
    else
      flash[:error] =  "MeetingInvitation failed to send"
    end
    redirect_back fallback_location: root_path
  end

  def observee_consistency_data
    chart = ObserveePrescriptionConsistencyChart.new(current_user)

    respond_to do |format|
      format.json do
        render json: {observees: chart.data}
      end
    end
  end

  # GET /users/new_clinician
  def observations
    @observer_entry = ObserverEntry.new
    # @observation = Observation.find_by(observer_id: current_user.id, member_id: params[:member_id])
    # @observer_update = ObserverEntry.update
    @user = current_user
    @observations = @user.observations_of_others.active.includes(:observee)
    @observer_entries = @user.observer_entries(observed_at: :desc)
    @clinicians = current_user.clinicians
    @new_user = User.new

    # Then will need to results action to put entries_prescriptions data into JSON chart
    if request.xhr?
      observees = current_user.
                  observees.
                  with_entries_prescriptions.
                  joins(:observations_on_me).
                  where(observations: {status: "active", guardian: true})

      chart_data = observees.map do |observee|
        { name: observee.user_id }
      end

      render json: chart_data
    end
  end

  def prescription_review
    @user = current_user
    @observations = @user.observations_of_others.active.includes(:observee)
    @observer_entries = @user.observer_entries(observed_at: :desc)
    @clinicians = current_user.clinicians
    @new_user = User.new
  end

  def make_observation
    @user = current_user
    @observations = @user.observations_of_others.active.includes(:observee)
    @observer_entries = @user.observer_entries(observed_at: :desc)
    @clinicians = current_user.clinicians
    @new_user = User.new

    if request.xhr?
      observees = current_user.
          observees.
          with_entries_prescriptions.
          joins(:observations_on_me).
          where(observations: {status: "active", guardian: true})

      chart_data = observees.map do |observee|
        { name: observee.user_id }
      end

      render json: chart_data
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = current_user
    end
    
    def user_params
      params.require(:user).permit(:id, :user_id, :email, :password, :observer_id, :clinician_id, :race, :gender, :dob, :weight, :zip_code, :nationality, :country,
                                   :occupation, :emergency_contact_name, :emergency_contact_num,
                                   :clinic_street, :clinic_city,
                                   :clinic_state, :clinic_zip, :clinician_type, :clinic_name, :diagnosis, :primary_role, :trial_interested)
    end
end
