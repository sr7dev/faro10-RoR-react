class Users::ExercisesMembershipsController < ApplicationController
  def index
    @assigned = ExercisesMembership.by_member(current_user)

    @membership = Membership.includes(:clinician).find_by(clinician_id: params[:clinician_id], member: current_user)  #need help getting this to work so i can add unasign for the users
  end

  def show
    @assigned = ExercisesMembership.includes(:exercise, :questions, :answers).find(params[:id])
    authorize! :read, @assigned
    if @assigned.complete?
      @patient = current_user
      render template: 'patients/exercises_memberships/show'
    end
  end

  def create
    authorize! :create, ExercisesMembership
    assigned = ExercisesMembership.new(exercises_membership_params)

    if assigned.save
      redirect_to assigned_exercise_path(assigned)
    else
      redirect_back fallback_location: root_path, flash: { error: "There was a problem." }
    end
  end

  def destroy
    em = ExercisesMembership.find(params[:id])
    authorize! :destroy, em
    if em.destroy
      respond_to do |format|
        # format.html { redirect_to :back, notice: 'Exercise has been unassigned.' }

        format.html { redirect_back fallback_location: root_path, flash:  {success: "Exercise has been unassigned."} }
        format.json { head :no_content }
      end
    else
      # another thing
    end
  end

  private

  def exercises_membership_params
    params.require(:exercises_membership).permit(:exercise_id, :membership_id).merge(assigned: Date.today)
  end
end
