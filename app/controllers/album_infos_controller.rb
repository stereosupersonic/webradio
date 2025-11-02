class AlbumInfosController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])
    @current_track = Rails.cache.read("current_track/#{@station.id}")

    if @current_track
      @spotify_album = Rails.cache.fetch("current_track/#{@current_track.key}", expires_in: 24.hours) do
        spotify_track = SpotifyTrack.new(artist: @current_track.artist, title: @current_track.title).call
        SpotifyAddToPlaylist.new(spotify_track: spotify_track).call if spotify_track
        Rails.logger.info "*******************************" if spotify_track
        Rails.logger.info "https://open.spotify.com/intl-de/track/#{spotify_track&.id}" if spotify_track
        Rails.logger.info "*******************************" if spotify_track
        spotify_track&.album
      end
    else
      Rails.logger.warn "No current track found for station #{@station.id}"
      @spotify_album = nil
    end
  end
end
