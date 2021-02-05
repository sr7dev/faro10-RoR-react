require 'rails_helper'

RSpec.describe "symptoms/new", type: :view do
  before(:each) do
    assign(:symptom, Symptom.new())
  end

  it "renders new symptom form" do
    render

    assert_select "form[action=?][method=?]", symptoms_path, "post" do
    end
  end
end
