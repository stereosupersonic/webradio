require "rails_helper"

RSpec.describe RadioboxLastTrack do
  let(:station) { create(:station, radio_box_url: "https://onlineradiobox.com/uk/absolute1058/playlist/") }
  #  RadioboxLastTrack.new(station: @station).call
end
