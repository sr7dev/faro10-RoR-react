require "rails_helper"

feature "clinician views patient collaboration page" do
  scenario "should render successfully" do
    clinician = create(:clinician)
    member = create(:member)
    membership = Membership.create(
      member_id: member.id,
      clinician_id: clinician.id,
      status: "active",
    )
    consent = create(
      :consent,
      membership_id: membership.id,
    )
    consent.ended_at = consent.created_at + 1.year
    consent.save
    consent.reload

    login_as clinician, scope: :user
    visit collaboration_patient_path(member)

    expect(page).to have_current_path(collaboration_patient_path(member))
    expect(page).to have_css "h3", text: "Collaborative Treatment"
  end
end
