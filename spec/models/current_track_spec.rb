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
