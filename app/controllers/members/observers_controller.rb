class Members::ObserversController < ApplicationController
  def create
    authorize! :create, Observation
    
    @observer = Member.find_by_email(observer_params[:observer_id])
    @clinician = Clinician.find_by_email(observer_params[:observer_id])
    # @observer = User.find_by_user_id(observer_params[:observer_id])  #This was the original variable that DAN created.  It searched for Observers by user_id and not email.

    if @observer
      @observation = Observation.inactive.find_or_initialize_by(member_id: current_user.id, observer_id: @observer.id)
      @observation.update(relationship: observer_params[:relationship], guardian: observer_params[:guardian], status: "active")

      flash[:success] = "Added Contact to your list."
    elsif @clinician
      flash[:danger] = "Clinicians cannot be added as contacts."
    else
      flash[:danger] = "Could not find Faro10 Member with that email."
    end

    redirect_back fallback_location: root_path
  end

  def edit
    @observations = Observation(member_id: current_user.id, observer_id: @observer.id)
    @observation = Observation.find(params[:id])
    authorize! :update, @observation
  end

  def update
    @observation = Observation.find(params[:id])
    authorize! :update, @observation

    if @observation.update_attributes(guardian: params[:guardian], relationship: params[:relationship])
      redirect_to observations_url, notice: 'Contact was successfully updated.'
    else
      render :edit 
    end
  end

  def destroy
    # @observer = User.find_by_user_id(observer_params[:observer_id])
    # @observation = Observation(member_id: current_user.id, observer_id: @observer.id)
    @observation = Observation.find(params[:id])
    authorize! :destroy, @observation

    if @observation
      @observation.update(status: "inactive")

      flash[:success] = "Removed Contact"
    else
      flash[:danger] = "Contact didn't exist"
    end
    redirect_back fallback_location: root_path
  end

  private

  def observer_params
    params.require(:observation).permit(:observer_id, :relationship, :guardian)
  end
end
