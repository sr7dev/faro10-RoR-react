class ObserversController < ApplicationController

  # GET /:func -> :set_member -> :func (order of operations of methods)
  #before_action :set_member, only: [:edit, :update, :show, :destroy]

  def index
    @observers = Observer.all
  end

  # GET /users/new
  def new
    @observer = Observer.new
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  def create
    @observer = Observer.new(user_params)
    if @observer.save
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  # Member adding an Observers ability to see the members prescriptions by marking the "guardian" column as "true"
  def add_meds_visibility
    @observation = Observation.find(params[:id])
    # current_user.observations.where(read: 0).update(read: 1)
    if @observation.present?
      if @observation.update(guardian: true)
        flash[:info] = "This Contact now has Guardian permission."
      else
        flash[:danger] = "There was an issue"
      end
    else
      flash[:danger] = "There was an issue"
    end
    redirect_back fallback_location: root_path
  end

  # Member removing an Observers ability to see the members prescriptions by marking the "guardian" column as "false"
  def remove_meds_visibility
    @observation = Observation.find(params[:id])
    # current_user.observations.where(read: 0).update(read: 1)
    if @observation.present?
      if @observation.update(guardian: false)
        flash[:info] = "This Contact no longer has Guardian permission."
      else
        flash[:danger] = "There was an issue"
      end
    else
      flash[:danger] = "There was an issue"
    end
    redirect_back fallback_location: root_path
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @observer.update_attributes(user_params)
        format.html { redirect_to @observer, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @observer }
      else
        format.html { render :edit }
        format.json { render json: @observer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.type == "Clinician"
      @observation = Observation.find_by(member_id: params[:id], clinician_id: current_user.id)
      # other_user_type == "Patient"
    else
      @observation = Observation.find_by(member_id: current_user.id, clinician_id: params[:id])
      # other_user_type == "Clinician"
    end

    if @observation.present?
      if @observation.destroy
        flash[:success] = "Removed Contact"
      else
        flash[:danger] = "Could not remove Contact"
      end
    else
      flash[:danger] = "Relationship didn't exist"
    end

    redirect_back fallback_location: root_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @observer = current_user
  end

  def set_member
    @observer = Observer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:observer).permit(:id, :user_id, :email, :password, :observer_id, :race, :gender, :dob, :weight, :zip_code, :nationality, :country, :occupation, :emergency_contact_name, :emergency_contact_num, :diagnosis, :type)
  end

end
