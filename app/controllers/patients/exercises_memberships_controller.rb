class Patients::ExercisesMembershipsController < ApplicationController
  # routed as patients/assigned_memberships
  
  def index
    @patient = Member.find(params[:patient_id])

    authorize! :read, @patient

    @membership = Membership.includes(:member).find_by(member_id: params[:patient_id], clinician: current_user)
    @assigned = ExercisesMembership.where(membership: @membership)
    @observers = @patient.observers
    # @observations = Observation.where(member_id: @patient.id, observer_id: @observers.id).take  #The observation table has the relationship & meds (is guardian) info
    @observations = @patient.observations_on_me.active
  end

  def show
    @patient = Member.find(params[:patient_id])

    authorize! :read, @patient

    @assigned = ExercisesMembership.includes(answers: :question).find(params[:id])
  end

  def pdf
    @patient = Member.find(params[:patient_id])

    authorize! :read, @patient

    @assigned = ExercisesMembership.includes(answers: :question).find(params[:id])

    pdf = AssignedExercisePdf.new(@assigned, @patient)

    respond_to do |format|
      format.pdf do
        send_data pdf.to_pdf, type: :pdf, disposition: "inline"
      end
    end
  end

  def create
    authorize! :create, ExercisesMembership

    em = ExercisesMembership.new(assigned_params)
    
    if em.save
      redirect_back fallback_location: root_path, flash: { success: "You have successfully assigned #{em.longname}." }
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

  def assigned_params
    params.require(:assigned).permit(:exercise_id, :membership_id, :due)
  end
end
