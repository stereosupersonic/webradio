require "rails_helper"

RSpec.describe SpotifyTrack do
  let(:artist) { "Test Artist" }
  let(:title) { "Test Title" }
  let(:service) { described_class.new(artist: artist, title: title) }

  describe "#initialize" do
    it "sets artist and title" do
      expect(service.artist).to eq(artist)
      expect(service.title).to eq(title)
    end
  end

  describe "#call" do
    context "when artist is blank" do
      let(:artist) { "" }

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "when title is blank" do
      let(:title) { nil }

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "when Spotify credentials are missing" do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("SPOTIFY_CLIENT_ID").and_return(nil)
      end

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "when Spotify credentials are present" do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("SPOTIFY_CLIENT_ID").and_return("test_client_id")
        allow(ENV).to receive(:[]).with("SPOTIFY_CLIENT_SECRET").and_return("test_client_secret")
      end

      context "when authentication succeeds" do
        let(:mock_track) { double("spotify_track") }

        before do
          allow(RSpotify).to receive(:authenticate).and_return(true)
          allow(RSpotify::Track).to receive(:search).with("#{artist} - #{title}").and_return([mock_track])
        end

        it "returns the first search result" do
          expect(service.call).to eq(mock_track)
        end

        it "authenticates with correct credentials" do
          expect(RSpotify).to receive(:authenticate).with("test_client_id", "test_client_secret")
          service.call
        end

        it "searches with correct query" do
          expect(RSpotify::Track).to receive(:search).with("Test Artist - Test Title")
          service.call
        end
      end

      context "when authentication fails" do
        before do
          allow(RSpotify).to receive(:authenticate).and_raise(StandardError.new("Auth failed"))
        end

        it "returns nil" do
          expect(service.call).to be_nil
        end

        it "logs authentication error" do
          expect(Rails.logger).to receive(:error).with("Spotify authentication error: Auth failed")
          service.call
        end
      end
    end
  end
end