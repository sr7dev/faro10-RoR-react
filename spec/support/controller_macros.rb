module ControllerMacros

  def login_connected_member
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      member = FactoryBot.create(:connected_member)
      sign_in member, scope: :user
    end
  end
end
