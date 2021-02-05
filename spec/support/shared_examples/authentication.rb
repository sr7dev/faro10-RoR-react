RSpec.shared_examples "authenticated route" do |method, path|
  context "unauthenticated user" do
    it "should redirect to login page" do
      public_send(
        method.downcase,
        path
      )

      expect(response).to redirect_to new_user_session_path
    end
  end
end
