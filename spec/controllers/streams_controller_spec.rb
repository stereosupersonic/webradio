require "rails_helper"

RSpec.describe StreamsController, type: :controller do
  let(:station) { create(:station, url: "http://example.com/stream.mp3") }

  describe "GET #show" do
    context "with mp3 format" do
      it "sets correct headers" do
        allow(Net::HTTP).to receive(:get_response).and_yield(double(read_body: []))

        get :show, params: { station_id: station.id }, format: :mp3

        expect(response.headers["Content-Type"]).to eq("audio/mpeg")
        expect(response.headers["Content-Disposition"]).to eq("inline")
      end

      it "handles streaming errors gracefully" do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new("Network error"))

        expect {
          get :show, params: { station_id: station.id }, format: :mp3
        }.not_to raise_error
      end
    end

    it "finds the correct station" do
      allow(Net::HTTP).to receive(:get_response).and_yield(double(read_body: []))

      expect(Station).to receive(:find).with(station.id.to_s).and_return(station)

      get :show, params: { station_id: station.id }, format: :mp3
    end
  end
end