class SchedulesController < ApplicationController

  before_action :set_member, only: [:show]
  before_action :set_observer, only: [:index]

  def index
    @appointment = Appointment.new
    @observees = @observer.observees

    if params[:observee_id]
      set_observee
      @appointments = @observee.appointments
    else
      if @observees.any?
        @observee = @observees.first
        @appointments = @observee.appointments
      else
        @appointments = []
      end
    end

    @appointments.each do |appointment|
      authorize! :read, appointment
    end

    @appointments_props = {
      appointments: @appointments.to_json
    }
  end

  def show
    @appointment = Appointment.new
    @appointments = @member.appointments

    @appointments.each do |appointment|
      authorize! :read, appointment
    end

    @appointments_props = {
      appointments: @appointments.to_json
    }
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
  end

  def set_observer
    @observer = current_user
  end

  def set_observee
    @observee = @observer.observees.find(params[:observee_id])
  end
end
