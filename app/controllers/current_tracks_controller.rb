class CurrentTracksController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])
    @current_track = RadioboxLastTrack.new(url: @station.radio_box_url).call if @station.radiobox.present?
    @last_fm = LastFmApi.new(artist: @current_track.artist, title: @current_track.title).call
  end
end
