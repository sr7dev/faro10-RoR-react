class AdminRole < AccessGranted::Role
  def configure
    
    can :manage, Admin
    can :manage, Alert
    can :manage, Appointment
    can :manage, Clinician
    can :manage, Drug
    can :manage, Entry
    can :manage, Exercise
    can :manage, ExercisesMembership
    can :manage, Group
    can :manage, Member
    can :manage, Membership
    can :manage, Observation
    can :mangae, PatientsController
    can :manage, Prescription
    can :manage, Question
    can :manage, Symptom
    can :manage, User
  end
end