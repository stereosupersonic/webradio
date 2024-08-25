require 'rails_helper'

RSpec.describe CurrentTrack, type: :model do
  it 'is valid with valid attributes' do
    current_track = CurrentTrack.new(artist: 'Artist', title: 'Title')
    expect(current_track).to be_valid
  end

  it 'returns a string representation' do
    current_track = CurrentTrack.new(artist: 'Artist', title: 'Title')
    expect(current_track.to_s).to eq('Artist - Title')
  end

  it 'generates a key based on artist and title' do
    current_track = CurrentTrack.new(artist: 'Artist', title: 'Title')
    expect(current_track.key).to eq('artist-title')
  end
end
require 'rails_helper'

RSpec.describe CurrentTrack, type: :model do
  let(:current_track) { CurrentTrack.new(artist: "Artist", title: "Title") }

  describe "#to_s" do
    it "returns the artist and title as a string" do
      expect(current_track.to_s).to eq("Artist - Title")
    end
  end

  describe "#key" do
    it "returns a parameterized key" do
      expect(current_track.key).to eq("artist-title")
    end
  end
end
