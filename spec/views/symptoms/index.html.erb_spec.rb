require 'rails_helper'

RSpec.describe "symptoms/index", type: :view do
  before(:each) do
    assign(:symptoms, [
      Symptom.create!(),
      Symptom.create!()
    ])
  end

  it "renders a list of symptoms" do
    render
  end
end
