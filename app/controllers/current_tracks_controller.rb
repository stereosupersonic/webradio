class CurrentTracksController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])

    current_track_by_steam = StreamLastTrack.new(url: @station.url).call unless @station.ignore_tracks_from_stream?

    Rails.logger.info "current_track_by: steam #{current_track_by_steam}" if current_track_by_steam
    @current_track = current_track_by_steam
    @current_track ||= RadioboxLastTrack.new(url: @station.radio_box_url).call
    Rails.logger.info "current_track_by: radiobox #{@current_track}" if @current_track && !current_track_by_steam

    @last_fm = if @current_track && params[:show_album_info] == "true"
      Rails.cache.fetch("current_track/#{@current_track.key}") do
        LastFmApi.new(artist: @current_track.artist, title: @current_track.title).call
      end
    end
  end
end
