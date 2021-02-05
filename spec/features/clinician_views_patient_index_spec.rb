require "rails_helper"

feature "clinician views patient index" do
  scenario "the patients table" do
    clinician = create(:clinician)
    patients = setup_members(clinician)

    login_as clinician, scope: :user
    visit patients_path

    expect(page).to have_content patients[0].user_id
    expect(page).to have_content patients[1].user_id
    expect(page).to have_content patients[2].user_id
    expect(page).to have_content patients[3].user_id
    expect(page).to have_content patients[4].user_id
  end

  def create_membership(member, clinician)
    membership = Membership.create(
      member_id: member.id,
      clinician_id: clinician.id,
      status: "active"
    )
    consent = create(
      :consent,
      membership_id: membership.id
    )
    consent.ended_at = consent.created_at + 1.year
    consent.save
    consent.reload

    membership
  end

  def setup_members(clinician)
    patients = [
      create(:member),
      create(:member),
      create(:member),
      create(:member),
      create(:member),
    ]

    patients.each do |patient|
      create_membership(patient, clinician)
    end

    patients
  end
end
