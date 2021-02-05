# require 'rails_helper'
#
# RSpec.describe "channels/edit", type: :view do
#   before(:each) do
#     @channel = assign(:channel, Channel.create!(
#       :channel_name => "MyString"
#     ))
#   end
#
#   it "renders the edit channel form" do
#     render
#
#     assert_select "form[action=?][method=?]", channel_path(@channel), "post" do
#
#       assert_select "input#channel_channel_name[name=?]", "channel[channel_name]"
#     end
#   end
# end
