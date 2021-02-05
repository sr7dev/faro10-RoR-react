class ObserverEntriesController < ApplicationController
  #before_action :set_entry, only: [:show, :edit, :update, :destroy]

  def create
    @observer_entry = ObserverEntry.new(observer_entry_params)
    if @observer_entry.save
      flash[:success] = "Your observation has been saved and is available to your Clinician."
      redirect_back fallback_location: root_path, success: "Observer Entry Added!"
    else
      @user = current_user
      @observations = @user.observations_of_others
      @observer_entries = @user.observer_entries
      @clinicians = current_user.clinicians
      @new_user = User.new
      render 'users/observations'
    end
  end



  #The edit and observe doesn't work yet
  def edit
    @observer_entry = ObserverEntry.find(params[:id])
    # @observations = @user.observations_of_others
    @observation = Observation.find_by(member_id: params[:id], observer_id: current_user.id)
    authorize! :update, @observer_entry
  end



  def update
    @observation = Observation.find_by(member_id: params[:id], observer_id: current_user.id)
    @observer_entry = ObserverEntry.find(params[:id])
    respond_to do |format|
      if @observer_entry.update_attributes(observer_entry_params)
        format.html { redirect_back fallback_location: root_path, notice: 'Observation was successfully updated.' }
        format.json { render :show, status: :ok, location: @observer_entry }
      else
        format.html { render :edit }
        format.json { render json: @observer_entry.errors, status: :unprocessable_entity }
      end
    end
  end
#  WIP above



  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_entry
    #   @entry = Entry.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def observer_entry_params
      params.require(:observer_entry).permit(:emotion, :feeling, :journal, :observation_id, :observed_at, :social_interaction,
      :delusional, :hallucination, :hyperactive, :energy, :activity, :zest, :work_life, :family_life,
                                             :dangerous_behavior, :substance_abuse, :clinician_response )
    end
end
