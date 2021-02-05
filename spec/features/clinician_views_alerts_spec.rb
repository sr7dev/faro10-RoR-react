require "rails_helper"

feature "clinician views alerts" do
  scenario "views patient alerts" do
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
    alert = create(
      :alert,
      member_id: member.id,
    )

    login_as clinician, scope: :user
    visit alerts_path

    expect(page).to have_content alert.alert_body
    expect(page).to have_current_path(alerts_path)
  end

  scenario "doesn't display alerts for an invalid membership" do
    clinician = create(:clinician)
    member = create(:member)
    Membership.create(
      member_id: member.id,
      clinician_id: clinician.id,
      status: "active",
    )
    alert = create(
      :alert,
      member_id: member.id,
    )

    login_as clinician, scope: :user
    visit alerts_path

    expect(page).to have_current_path(alerts_path)
    expect(page).not_to have_content alert.alert_body
  end
end
