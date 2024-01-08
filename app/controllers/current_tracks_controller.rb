class CurrentTracksController < ApplicationController
  def index
    station = StationPresenter.new Station.find(params[:station_id])
    current_track = RadioboxLastTrack.new(url: station.radio_box_url).call if station.radiobox.present?

    last_fm = LastFmApi.new(artist: current_track.artist, title: current_track.title).call if params[:show_album_info] == "true"

    render partial: "index", locals: { current_track: current_track, last_fm: last_fm }
  end
end
