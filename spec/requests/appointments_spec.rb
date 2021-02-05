# require "rails_helper"
#
# describe "Appointments" do
#   it_behaves_like "authenticated route", "GET", "/appointments/new"
#   it_behaves_like "authenticated route", "POST", "/appointments"
#   it_behaves_like "authenticated route", "GET", "/appointments/:id"
#   it_behaves_like "authenticated route", "DELETE", "/appointments/:id"
#
#   describe "GET /appointments/:id" do
#     it " should render the appointment show page" do
#       member = create(:member)
#       clinician = create(:clinician)
#       appointment = create(
#         :appointment,
#         member_id: member.id,
#         created_by: clinician.id,
#         duration: 30,
#         start_time: DateTime.new(2017, 10, 1, 11),
#       )
#
#       login_as(clinician, :scope => :user)
#       get "/appointments/#{appointment.id}"
#
#       expect(assigns(:appointment)).to eq(appointment)
#     end
#   end
# end
