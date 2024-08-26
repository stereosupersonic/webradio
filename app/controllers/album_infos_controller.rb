class AlbumInfosController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])
    @current_track = Rails.cache.read("current_track/#{@station.id}")

    if @current_track
      @spotify_album = Rails.cache.fetch("current_track/#{@current_track.key}", expires_in: 24.hours) do
        spotify_track = SpotifyTrack.new(artist: @current_track.artist, title: @current_track.title).call
        spotify_track&.album
      end
    else
      Rails.logger.warn "No current track found for station #{@station.id}"
      @spotify_album = nil
    end
  end
end
