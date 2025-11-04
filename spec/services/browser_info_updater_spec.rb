require "rails_helper"

RSpec.describe BrowserInfoUpdater do
  let(:station) { create(:station, browser_info_byuuid: "test-uuid-123") }
  let(:service) { described_class.new(station: station) }

  describe "#call" do
    context "when station has no browser_info_byuuid" do
      let(:station) { create(:station, browser_info_byuuid: nil) }

      it "returns true without making API call" do
        expect(Net::HTTP).not_to receive(:get_response)
        expect(service.call).to be_truthy
      end
    end

    context "when station is locked" do
      let(:station) { create(:station, browser_info_byuuid: "test-uuid", locked: true) }

      it "returns true without making API call" do
        expect(Net::HTTP).not_to receive(:get_response)
        expect(service.call).to be_truthy
      end
    end

    context "when API call is successful" do
      let(:mock_response) { double("response", is_a?: true, body: api_response_body) }
      let(:api_response_body) do
        '[{"url_resolved":"http://updated.com","name":"Updated Name","favicon":"http://updated.com/favicon.ico","homepage":"http://updated.com"}]'
      end

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(mock_response)
        allow(mock_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      end

      it "updates station with API data" do
        service.call
        station.reload

        expect(station.url).to eq("http://updated.com")
        expect(station.name).to eq("Updated Name")
        expect(station.logo_url).to eq("http://updated.com/favicon.ico")
        expect(station.homepage).to eq("http://updated.com")
      end

      it "does not overwrite existing name if present" do
        station.update!(name: "Existing Name")
        service.call
        station.reload

        expect(station.name).to eq("Existing Name")
      end

      it "does not overwrite existing logo_url if present" do
        station.update!(logo_url: "http://existing.com/logo.png")
        service.call
        station.reload

        expect(station.logo_url).to eq("http://existing.com/logo.png")
      end

      it "returns true" do
        expect(service.call).to be_truthy
      end
    end

    context "when API call fails" do
      let(:mock_response) { double("response", is_a?: false, message: "Not Found") }

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(mock_response)
        allow(mock_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      end

      it "returns false" do
        expect(service.call).to be_falsey
      end

      it "logs error message" do
        expect(Rails.logger).to receive(:error).with("Failed to fetch data: Not Found")
        service.call
      end
    end

    context "when exception occurs" do
      before do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new("Network error"))
      end

      it "handles exception gracefully" do
        expect { service.call }.not_to raise_error
      end

      it "logs error message" do
        expect(Rails.logger).to receive(:error).with("Station: #{station.name} - Failed to fetch data: Network error")
        service.call
      end
    end
  end
end