require "rails_helper"

feature "member visits their dashboard" do
  scenario "views dashboard stats" do
    member = setup_member

    # Test user for authorization
    other = create(:member)
    entry = create(:entry, member: other, created_at: Date.new(2017, 10, 11))

    entries = member.entries.order("created_at DESC")

    # Only current_users data
    # expect(page).not_to have_content entry.created_at.strftime("%B %d, %A")
    #
    # expect(page).to have_content member.user_id
    # expect(page).to have_css "span", text: entries.first.created_at.strftime("%B %d, %A")
    # expect(page).to have_css "span", text: entries.count
    # expect(page).to have_css "p", text: entries.fourth.journal
    # expect(page).to have_css "p", text: entries.fifth.journal
  end

  def setup_member
    member = create(:member)

    create_entries(member)
    member.reload

    login_as(member, :scope => :user)
    # visit dashboard_path

    member
  end

  def create_entries(member)
    create(:entry, member: member, created_at: Date.new(2017, 10, 10))
    create(:entry, member: member, created_at: Date.new(2017, 10, 9))
    create(:entry, member: member, created_at: Date.new(2017, 10, 8))
    create(
      :entry,
      member: member,
      created_at: Date.new(2017, 10, 7),
      journal: "This is a journal entry",
    )
    create(
      :entry,
      member: member,
      created_at: Date.new(2017, 10, 6),
      journal: "This is the second journal entry",
    )
  end
end
