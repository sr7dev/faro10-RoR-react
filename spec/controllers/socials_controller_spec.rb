require 'rails_helper'

describe SocialsController, type: :controller do
  describe "GET index" do
    
    login_connected_member

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    it "should get index" do
      get 'index'
      expect(response).to have_http_status(:success)
    end

    it "sets the start date to 15 days before start of current year" do
      new_time = Time.local(2008, 9, 1, 12, 0, 0)

      Timecop.freeze(new_time) do
        get :index
        expect(assigns(:start_date)).to eq(Date.new(2008, 1, 1))
      end
    end

    it "sets end date to today" do
      new_time = Time.local(2008, 9, 1, 12, 0, 0)

      Timecop.freeze(new_time) do
        get :index
        expect(assigns(:end_date)).to eq(Date.new(2008,9,1))
      end
    end
  end
end
