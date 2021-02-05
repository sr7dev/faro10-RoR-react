class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments/:id
  def show
    authorize! :read, @appointment
    @member = Member.find(@appointment.member_id)
    @creator = User.find(@appointment.created_by)
  end

  # GET /appointments/new
  def new
    authorize! :create, Appointment

    @member = Member.find(params[:member_id])
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        if current_user.is_a? Clinician
          Clinicians::MemberMailer.delay.new_appointment(@appointment)
        end
        
        flash[:success] = 'Appointment was successfully created.'

        if @appointment.member.observers.pluck(:id).include? @appointment.created_by
          format.html { redirect_to schedules_path(observee_id: @appointment.member_id) }
        else
          format.html { redirect_to schedule_path(@appointment.member_id) }
        end
      else
        @member = Member.find(@appointment.member_id)
        flash[:danger] = 'Appointment could not be created.'
        format.html { render action: 'new' }
      end
    end
  end

  # DELETE /appointments/1
  def destroy
    authorize! :destroy, @appointment
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to schedule_path(@appointment.member_id) }
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:created_by, :duration, :member_id, :start_time, :title)
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end
end

