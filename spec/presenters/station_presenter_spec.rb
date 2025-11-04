require "rails_helper"

RSpec.describe StationPresenter do
  let(:station) { create(:station, logo_url: "http://example.com/logo.png", radiobox: "uk/radio1", browser_info_byuuid: "test-uuid-123") }
  let(:presenter) { described_class.new(station) }

  describe "#station_logo" do
    it "returns the station's logo_url" do
      expect(presenter.station_logo).to eq("http://example.com/logo.png")
    end
  end

  describe "#radio_box_url" do
    it "returns the correct radiobox URL" do
      expect(presenter.radio_box_url).to eq("https://onlineradiobox.com/uk/radio1/playlist/")
    end

    context "when radiobox is nil" do
      let(:station) { create(:station, radiobox: nil) }

      it "handles nil radiobox gracefully" do
        expect(presenter.radio_box_url).to eq("https://onlineradiobox.com//playlist/")
      end
    end
  end

  describe "#browser_info_url" do
    it "returns the correct browser info URL" do
      expect(presenter.browser_info_url).to eq("https://www.radio-browser.info/history/test-uuid-123")
    end

    context "when browser_info_byuuid is nil" do
      let(:station) { create(:station, browser_info_byuuid: nil) }

      it "handles nil browser_info_byuuid gracefully" do
        expect(presenter.browser_info_url).to eq("https://www.radio-browser.info/history/")
      end
    end
  end

  describe "delegation" do
    it "delegates method calls to the station object" do
      expect(presenter.name).to eq(station.name)
      expect(presenter.url).to eq(station.url)
    end
  end
end
