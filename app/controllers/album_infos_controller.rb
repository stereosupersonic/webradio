class AlbumInfosController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])
    @current_track = Rails.cache.read("current_track/#{@station.id}")

    @last_fm = if @current_track
      Rails.cache.fetch("current_track/#{@current_track.key}") do
        LastFmApi.new(artist: @current_track.artist, title: @current_track.title).call
      end
    end
  end
end
