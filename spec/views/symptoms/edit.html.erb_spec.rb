require 'rails_helper'

RSpec.describe "symptoms/edit", type: :view do
  before(:each) do
    @symptom = assign(:symptom, Symptom.create!())
  end

  it "renders the edit symptom form" do
    render

    assert_select "form[action=?][method=?]", symptom_path(@symptom), "post" do
    end
  end
end
