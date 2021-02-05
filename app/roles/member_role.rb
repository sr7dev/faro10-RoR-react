class MemberRole < AccessGranted::Role
  def configure
    can :create, Alert
    can [:read, :update, :destroy], Alert do |alert, member|
      member == alert.member
    end

    can :create, Appointment
    can [:read, :destroy], Appointment do |appointment, member|
      (member == appointment.member) || (member.observees.include? appointment.member)
    end

    can :create, Channel
    can [:read, :update, :destroy, :edit], Channel

    can :read, Clinician

    can :create, Diagnosis
    can [:read, :update, :new, :destroy], Diagnosis do |diagnosis, member|
      member == diagnosis.member
    end

    can :create, Entry
    can :read, Entry do |entry, member|
      member.id == entry.member_id
    end

    can :read, Exercise
    
    can :create, ExercisesMembership
    can [:read, :destroy], ExercisesMembership do |exercises_memebership, member|
      member.memberships.include? exercises_memebership.membership
    end

    can [:read, :update], Member do |patient, member|
      member == patient
    end

    can [:read, :update, :destroy, :accept, :cancel, :deny, :renew], Membership do |membership, member|
      membership.member == member
    end

    can :create, Message
    can [:read, :update, :destroy], Message do |message, member|
      member.id == message.member_id
    end

    can :create, Meeting
    can [:read, :update, :destroy, :edit, :join, :follow, :unfollow], Meeting
    # TODO: Meetings should be limited down to just people that are invited by creator

    can :create, MeetingMessage
    can [:read, :update, :destroy, :edit], MeetingMessage

    can :create, Observation
    can [:read, :update, :destroy], Observation do |observation, member|
      (observation.observer == member) || (observation.member_id == member.id)
    end

    can :create, Prescription
    can [:read, :update, :destroy], Prescription do |prescription, member|
      member == prescription.member
    end

    can :create, Symptom
    can [:read, :update], Symptom do |symptom, member|
      (Symptom.default.include? symptom) || (symptom.patient_id == member.id)
    end

    can [:read, :update], User do |user, member|
      member == user
    end
  end
end
