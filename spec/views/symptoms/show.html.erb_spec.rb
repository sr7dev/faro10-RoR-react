require 'rails_helper'

RSpec.describe "symptoms/show", type: :view do
  before(:each) do
    @symptom = assign(:symptom, Symptom.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
