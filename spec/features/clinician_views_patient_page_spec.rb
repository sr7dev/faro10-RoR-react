require "rails_helper"

feature "clinician views patients page" do

  before(:each) do
    @clinician = create(:clinician)
    @member = create(:member)
    @membership = Membership.create(
      member_id: @member.id,
      clinician_id: @clinician.id,
      status: "active",
    )
    @consent = create(
      :consent,
      membership_id: @membership.id,
    )
    @consent.ended_at = @consent.created_at + 1.year
    @consent.save
    @consent.reload
  end

  scenario "should render only prescriptions that should be visible" do
    other_member = create(:member)
    prescription = create(
      :prescription,
      :advil,
      member_id: @member.id
    )
    other_prescription = create(
      :prescription,
      :abilify,
      member_id: other_member.id,
    )
    login_as @clinician, scope: :user
    visit patient_path(@member)

    expect(page).to have_current_path(patient_path(@member))
    expect(page).to have_content prescription.drug.friendly_name
    expect(page).not_to have_content other_prescription.drug.friendly_name
  end
end
