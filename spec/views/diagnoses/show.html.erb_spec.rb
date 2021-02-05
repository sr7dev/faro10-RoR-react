require 'rails_helper'

RSpec.describe "diagnoses/show", type: :view do
  before(:each) do
    @diagnosis = assign(:diagnosis, Diagnosis.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
