class CliniciansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search]
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  layout "static", only: [:new, :create]

  def index
    @clinicians = Clinician.all
  end

  def clinic_dashboard
    if request.xhr?
      @members = Member.joins(:memberships).where(memberships: {clinician: current_user}).uniq

      @start =  params[:start_date]
      @end = params[:end_date]

      if(@start.present? and @end.present?)
        @start = Date.strptime(@start, "%m/%d/%Y").beginning_of_day
        @end = Date.strptime(@end, "%m/%d/%Y").end_of_day
      else
        @start = (current_user.created_at).beginning_of_day
        @end = Time.zone.now.end_of_day
      end

      @members = @members.active_during(@start..@end)

      if(params[:race]).present?
        @members = @members.by_race(params[:race])
      end

      if(params[:gender]).present?
        @members = @members.by_gender(params[:gender])
      end

      if(params[:diagnosis]).present?
        @members = @members.by_diagnosis(params[:diagnosis])
      end

      if params[:age_start].present?
        group = [params[:age_start].to_i, params[:age_end].to_i]
        @members = @members.age_group(group)
      end

      if(params[:prescription]).present?
        drug = Drug.find_by(friendly_name: params[:prescription])
        @members = @members.joins(:prescriptions).where(prescriptions: {drug_id: drug.id})
      end

      ### END @members SETUP ###

      if(params[:prescription]).present?
        @members = @members.by_prescription(params[:prescription])

        @meds_data = Array[{
          name: params[:prescription],
          y: @members.count
        }]
      else
        @meds_data = Drug.all_names.each_with_object([]) do |drug, arr|
          users = @members.by_prescription(drug)

          if users.any?
            arr << {name: drug, y: users.count}
          end
        end
      end

      if(params[:diagnosis]).present?
        @members = @members.by_diagnosis(params[:diagnosis])
        @diagnosis_data = Array[{name: params[:diagnosis],
                                 y: @members.count}]
      else
        @diagnosis_data = User.all_diagnosis.each_with_object(Array.new) do |diag, arr|
          perc = (@members.where(diagnosis: diag).count.to_f)/(@members.count)

          if perc > 0
            arr.push({name: diag, y: perc})
          end
        end
      end

      if params[:age_start].present?
        group = [params[:age_start].to_i, params[:age_end].to_i]
        @members = @members.age_group(group)

        @age_range_data = Array[{
            name: "#{group[0]} - #{group[1]}",
            y: @members.age_group(group).count
        }]
      else
        @age_range_data = User::AGE_GROUPS.each_with_object([]) do |range, arr|
          name  = "#{range[0]} - #{range[1]}"
          count = @members.age_group(range).count

          if count > 0
            arr.push({name: name, y: count})
          end
        end

        no_age_count = @members.to_a.count { |m| m.age.kind_of?(String) }
        @age_range_data << {name: 'None Provided', y: no_age_count}
      end

      @members.each do |m|
        puts "#{m.user_id} - #{m.dob} - #{m.age}"
      end

      results = {
        members: {
          count: @members.count
        },
        charts: {
          members: {
            count: @members.active_membership_count_grouped_by_date
          },
          diagnosis: {name: "Diagnosis",   colorByPoint: true, data: @diagnosis_data},
          age_range: {name: "Age Range",   colorByPoint: true, data: @age_range_data},
          meds:      {name: "Medications", colorByPoint: true, data: @meds_data}
        }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: results }
    end

  end

  # GET /users/new
  def new
    authorize! :create, Clinician
    @clinician = Clinician.new
  end

  def show
    @clinician = Clinician.find(params[:id])
    authorize! :read, @clinician
  end

  # GET /users/1/edit
  def edit
    @clinician = Clinician.find(params[:id])
    authorize! :update, @clinician
  end

  def create
    authorize! :create, Clinician
    @clinician = Clinician.new(user_params)
    if @clinician.save
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end
  
  # PATCH/PUT /Clinicians/1
  # PATCH/PUT /Clinicians/1.json
  def update
    authorize! :update, @clinician
    respond_to do |format|
      if password_update?
        if @clinician.update_with_password(user_params)
          sign_in(:user, @clinician, :bypass => true)
          flash[:success] = "Account was successfully updated."
          format.html { redirect_to @clinician }
          format.json { render :show, status: :ok, location: @clinician }
        else
          format.html { render :edit }
          format.json { render json: @clinician.errors, status: :unprocessable_entity }
        end
      else
        if @clinician.update_without_password(user_params.except(:current_password))
          sign_in(:user, @clinician, :bypass => true)
          flash[:success] = "Account was successfully updated."
          format.html { redirect_to @clinician }
          format.json { render :show, status: :ok, location: @clinician }
        else
          format.html { render :edit }
          format.json { render json: @clinician.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize! :destroy, @clinician
    @clinician.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
        flash[:danger] = "User was successfully destroyed."

      format.json { head :no_content }
    end
  end

  # GET /clinicians/search
  def search
    @zip = params[:zip_code]
    @clinicians  = Clinician.featured.near_zip(@zip)

    respond_to do |format| 
      format.js

      format.json do
        @clinicians = clinicians.present? ? clinicians : Clinician.all
        render json: @clinicians
      end
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @clinician = current_user
  end

  def user_params
    params.require(:clinician).permit(
      :id,
      :user_id,
      :clinician_id,
      :email,
      :password,
      :observer_id,
      :race,
      :gender,
      :dob,
      :weight,
      :zip_code,
      :nationality,
      :country,
      :occupation,
      :emergency_contact_name,
      :emergency_contact_num,
      :diagnosis,
      :type,
      :clinic_street,
      :clinic_state,
      :clinic_zip,
      :clinician_type,
      :clinic_phone,
      :clinic_name,
      :is_clinician,
      :address,
      :latitude,
      :longitude,
      :password_confirmation,
      :current_password,
      :time_zone,
      :allow_sms_notifications,
    )
  end

  def password_update?
    user_params[:password].present? && user_params[:password_confirmation].present?
  end
  
end
