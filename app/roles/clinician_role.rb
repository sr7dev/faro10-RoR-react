class ClinicianRole < AccessGranted::Role
  def configure

    can :create, Alert
    can [:read, :update, :destroy], Alert do |alert, clinician|
      (clinician.members.include? alert.member) && (membership(clinician, alert.member).journal_visible?)
    end

    can :create, Appointment
    can [:read, :destroy], Appointment do |appointment, clinician|
      (clinician.active_members.include? appointment.member) && (membership(clinician, appointment.member).is_valid?)
    end

    can :read, Clinician
    can :update, Clinician do |c, clinician|
      c == clinician
    end

    can :create, ClinicianEntry
    can :read, ClinicianEntry do |clinician_entry, clinician|
      clinician.active_members.include? clinician_entry.member
    end

    can :create, Diagnosis
    can [:read, :update, :destroy], Diagnosis do |diagnosis, clinician|
      (clinician.active_members.include? diagnosis.member) && (membership(clinician, diagnosis.member).is_valid?)
    end

    can :read, Entry do |entry, clinician|
      (clinician.active_members.include? entry.member) && (membership(clinician, entry.member).is_valid?) && entry.within_membership(membership)
    end

    can :manage, Exercise
    can :manage, ExercisesMembership

    can [:create, :read], Group
    can [:update, :destroy], Group do |group, clinician|
      clinician.group == group
    end

    can :read, Member do |member, clinician|
      (clinician.members.include? member)
    end

    can [:create, :request], Membership
    can [:read, :update], Membership do |membership, clinician|
      membership.clinician == clinician
    end


    can :create, Message
    can [:read, :update, :destroy], Message do |message, member|
      member.id == message.member_id
    end

    can :create, Meeting
    can [:read, :update, :destroy, :edit], Meeting


    can :create, Observation
    can :read, Observation do |observation, clinician|
      (clinician.active_members.include? observation.observee) && (membership(clinician, observation.observee).is_valid?)
    end

    can :access, PatientsController

    can :create, Prescription
    can [:read, :update, :destroy], Prescription do |prescription, clinician|
      (clinician.active_members.include? prescription.member) && (membership(clinician, prescription.member).is_valid?)
    end

    can [:read, :update], User do |user, clinician|
      (clinician == user) || (clinician.active_members.include? user)
    end
  end

  private

  def membership(clinician, member)
    Membership.find_by(clinician: clinician, member: member)
  end
end
