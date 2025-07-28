class CurrentTracksController < ApplicationController
  def index
    station_record = Station.find_by(id: params[:station_id])
    if station_record
      @station = StationPresenter.new Station.find(station_record)
      @current_track = StreamLastTrack.new(station: @station).call || RadioboxLastTrack.new(station: @station).call

      Rails.logger.info "#{@station.name} current_track_by: #{@current_track.source} - #{@current_track}" if @current_track
      Rails.logger.info "#{@station.name} no current_track" unless @current_track

      Rails.cache.write("current_track/#{@station.id}", @current_track) if @current_track
    else
      @station = nil
      @current_track = nil
      Rails.logger.error "Station not found with id: #{params[:station_id]}"
    end
  end
end
