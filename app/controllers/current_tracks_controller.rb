class CurrentTracksController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])

    @current_track = StreamLastTrack.new(station: @station).call || RadioboxLastTrack.new(station: @station).call

    Rails.logger.info "#{@station.name} current_track_by: #{@current_track.source} - #{@current_track}" if @current_track
    Rails.logger.info "#{@station.name} no current_track" unless @current_track

    Rails.cache.write("current_track/#{@station.id}", @current_track) if @current_track
  end
end
