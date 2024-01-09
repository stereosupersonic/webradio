class CurrentTracksController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])

    if @station.radiobox.present?
      @current_track = RadioboxLastTrack.new(url: @station.radio_box_url).call
      # cache album infos for 24h
      @last_fm = if @current_track && params[:show_album_info] == "true"
        cache_key = "current_track/#{@current_track.artist}-#{@current_track.title}".parameterize
        Rails.cache.fetch(cache_key, expires_in: 24.hours) do
          LastFmApi.new(artist: @current_track.artist, title: @current_track.title).call
        end
      end
    end
  end
end
