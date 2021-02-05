require 'rails_helper'

RSpec.describe "diagnoses/new", type: :view do
  before(:each) do
    assign(:diagnosis, Diagnosis.new())
  end

  it "renders new diagnosis form" do
    render

    assert_select "form[action=?][method=?]", diagnoses_path, "post" do
    end
  end
end
