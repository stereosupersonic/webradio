require 'rails_helper'

RSpec.describe CurrentTracksController, type: :controller do
  describe 'GET #index' do
    let(:station) { create(:station) }
    let(:current_track) { double('CurrentTrack', source: 'stream', to_s: 'Track Info') }

    before do
      allow(StationPresenter).to receive(:new).and_return(station)
      allow(StreamLastTrack).to receive(:new).and_return(double(call: current_track))
      allow(RadioboxLastTrack).to receive(:new).and_return(double(call: nil))
    end

    it 'assigns @current_track' do
      get :index, params: { station_id: station.id }
      expect(assigns(:current_track)).to eq(current_track)
    end

    it 'writes @current_track to cache' do
      expect(Rails.cache).to receive(:write).with("current_track/#{station.id}", current_track)
      get :index, params: { station_id: station.id }
    end

    it 'logs the current track information' do
      expect(Rails.logger).to receive(:info).with("#{station.name} current_track_by: #{current_track.source} - #{current_track}")
      get :index, params: { station_id: station.id }
    end
  end
end
require 'rails_helper'

RSpec.describe CurrentTracksController, type: :controller do
  describe 'GET #index' do
    let(:station) { create(:station) }
    let(:current_track) { double('CurrentTrack', source: 'stream', to_s: 'Track Info') }

    before do
      allow(Station).to receive(:find).and_return(station)
      allow(StationPresenter).to receive(:new).and_return(station)
      allow(StreamLastTrack).to receive(:new).and_return(double(call: current_track))
      allow(RadioboxLastTrack).to receive(:new).and_return(double(call: nil))
    end

    it 'assigns @current_track' do
      get :index, params: { station_id: station.id }
      expect(assigns(:current_track)).to eq(current_track)
    end

    it 'writes @current_track to cache' do
      expect(Rails.cache).to receive(:write).with("current_track/#{station.id}", current_track)
      get :index, params: { station_id: station.id }
    end

    it 'logs the current track information' do
      expect(Rails.logger).to receive(:info).with("#{station.name} current_track_by: #{current_track.source} - #{current_track}")
      get :index, params: { station_id: station.id }
    end

    it 'logs when there is no current track' do
      allow(StreamLastTrack).to receive(:new).and_return(double(call: nil))
      allow(RadioboxLastTrack).to receive(:new).and_return(double(call: nil))
      expect(Rails.logger).to receive(:info).with("#{station.name} no current_track")
      get :index, params: { station_id: station.id }
    end
  end
end
