class AccessPolicy
  include AccessGranted::Policy

  def configure
    role :admin, AdminRole, lambda { |admin| admin.is_a? Admin }
    role :clinician, ClinicianRole, lambda {|clinician| clinician.is_a? Clinician }
    role :member, MemberRole, lambda { |member| member.is_a? Member }
    role :guest, GuestRole, lambda {|guest| guest}
  end
end
