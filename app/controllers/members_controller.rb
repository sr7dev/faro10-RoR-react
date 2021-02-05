class MembersController < ApplicationController
  before_action :set_member, only: [:edit, :update, :show, :destroy]
  layout "static", only: [:new, :create]

  def index
    @members = Member.all
  end

  # GET /users/new
  def new
    @member = Member.new
  end

  # GET /users/1
  def show
    authorize! :read, @member
  end

  # GET /users/1/edit
  def edit
    authorize! :update, @member

    respond_to do |format|
      format.html { @diagnoses = MedicalCondition.dsm5_diagnosis }
      format.json { @diagnoses = MedicalCondition.dsm5_diagnosis }
    end
  end

  def create
    @member = Member.new(user_params)
    if @member.save
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @member
    respond_to do |format|
      if password_update?
        if @member.update_with_password(user_params)
          sign_in(:user, @member, bypass: true)
          flash[:success] = "Account was successfully updated!"
          format.html { redirect_back fallback_location: root_path }
          format.json { render :show, status: :ok, location: @member }
        else
          format.html { render :edit }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      else
        if @member.update_without_password(user_params.except(:current_password))
          sign_in(:user, @member, bypass: true)
          # flash[:success] = "Account was successfully updated!"
          format.html { redirect_back fallback_location: root_path }
          format.json { render :show, status: :ok, location: @member }
        else
          format.html { render :edit }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    def set_user
      @member = current_user
    end

    def set_member
      @member = Member.find(params[:id])
    end

    def user_params
      params.require(:member).permit(:id, :user_id, :email, :password, :observer_id, :race, :gender, :dob, :weight, :zip_code, :nationality, :country, :occupation,
                                     :emergency_contact_name, :emergency_contact_num, :diagnosis, :type, :address, :latitude, :longitude, :clinic_street, :clinic_city,
                                     :clinic_state, :clinic_zip, :password_confirmation, :current_password, :time_zone, :primary_role, :trial_interested, :about, :qualification)
    end

    def password_update?
      user_params[:password].present? && user_params[:password_confirmation].present?
    end
end
