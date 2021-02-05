require 'rails_helper'

RSpec.describe "diagnoses/edit", type: :view do
  before(:each) do
    @diagnosis = assign(:diagnosis, Diagnosis.create!())
  end

  it "renders the edit diagnosis form" do
    render

    assert_select "form[action=?][method=?]", diagnosis_path(@diagnosis), "post" do
    end
  end
end
