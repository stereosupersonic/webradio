class TrackInfosController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])
    @current_track = Rails.cache.read("current_track/#{@station.id}")

    @chat_gpt_said = if @current_track

      cache_key = "v1/current_track_chat_gpt/#{@current_track.key}".parameterize
      Rails.logger.info "TrackInfosController: cache_key: #{cache_key}"
      Rails.cache.fetch(cache_key, expires_in: 24.hours) do
        TrackInfoChatGpt.new(artist: @current_track.artist, title: @current_track.title).call
      end
    end
  end
end
