class CurrentTracksController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])

    if @station.radiobox.present?
     # @current_track = RadioboxLastTrack.new(url: @station.radio_box_url).call
      @current_track = StreamLastTrack.new(url: @station.url).call
      @current_track ||= RadioboxLastTrack.new(url: @station.radio_box_url).call
      @last_fm = if @current_track && params[:show_album_info] == "true"
        cache_key = "current_track/#{@current_track.artist}-#{@current_track.title}".parameterize
        Rails.cache.fetch(cache_key) do
          LastFmApi.new(artist: @current_track.artist, title: @current_track.title).call
        end
      end
    end
  end
end
