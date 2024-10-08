# == Schema Information
#
# Table name: stations
#
#  id                        :bigint           not null, primary key
#  browser_info_byuuid       :string
#  change_track_info_order   :boolean          default(FALSE), not null
#  country                   :string
#  description               :text
#  homepage                  :string
#  ignore_tracks_from_stream :boolean          default(FALSE), not null
#  logo_url                  :text
#  name                      :string
#  position                  :integer          default(100)
#  radiobox                  :string
#  url                       :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_stations_on_position  (position)
#
require "rails_helper"

RSpec.describe Station, type: :model do
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:name) }

  describe ".ordered" do
    it "returns stations ordered by position" do
      station1 = Station.create!(name: "Station 1", url: "http://example.com/1", position: 2)
      station2 = Station.create!(name: "Station 2", url: "http://example.com/2", position: 1)
      expect(Station.ordered).to eq([ station2, station1 ])
    end
  end

  describe ".create_by_browser_info" do
    it "creates a station with browser info" do
      byuuid = "some-uuid" + SecureRandom.uuid
      response = double("response", is_a?: true, body: '[{"url_resolved":"http://example.com","name":"Example","favicon":"http://example.com/favicon.ico","homepage":"http://example.com"}]')
      expect(Net::HTTP).to receive(:get_response).with(URI.parse("http://91.132.145.114/json/stations/byuuid/#{byuuid}")).and_return(response)

      station = Station.create_by_browser_info(byuuid)
      expect(station).to be_persisted
      expect(station.browser_info_byuuid).to eq(byuuid)
    end

    it "returns nil if byuuid is blank" do
      expect(Station.create_by_browser_info(nil)).to be_nil
    end
  end
end
