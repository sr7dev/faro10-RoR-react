require 'rails_helper'

RSpec.describe "diagnoses/index", type: :view do
  before(:each) do
    assign(:diagnoses, [
      Diagnosis.create!(),
      Diagnosis.create!()
    ])
  end

  it "renders a list of diagnoses" do
    render
  end
end
