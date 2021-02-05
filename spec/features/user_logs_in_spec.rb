# require "rails_helper"
#
# feature "user logs in" do
#   scenario "with incorrect email/password combo" do
#     visit new_user_session_path
#
#     fill_in "user_email", with: "test@example.com"
#     fill_in "user_password", with: "abc123"
#     click_button "Log in"
#
#     expect(page).to have_current_path(new_user_session_path)
#   end
#
#   scenario "as member with correct email/password combo" do
#     member = create(:member)
#
#     visit root_path
#     click_link "Log in"
#     fill_in "user_email", with: member.email
#     fill_in "user_password", with: member.password
#     click_button "Log in"
#
#     expect(page).to have_current_path(meetings_path)
#   end
#
#   scenario "as clinician with correct email/password combo" do
#     clinician = create(:clinician)
#
#     visit root_path
#     click_link "Log in"
#     fill_in "user_email", with: clinician.email
#     fill_in "user_password", with: clinician.password
#     click_button "Log in"
#
#     expect(page).to have_current_path(patients_path)
#   end
# end
