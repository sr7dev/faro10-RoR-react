# require "rails_helper"
#
# describe "/dashboard" do
#   it_behaves_like "authenticated route", "GET", "/dashboard"
#
#   describe "GET /dashboard" do
#     it "it should render the dashboard" do
#       member = create(:member)
#
#       login_as(member, :scope => :user)
#       get "/dashboard"
#
#       expect(response).to render_template :show
#     end
#   end
# end
