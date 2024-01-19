class CurrentTracksController < ApplicationController
  def index
    @station = StationPresenter.new Station.find(params[:station_id])

    @current_track = StreamLastTrack.new(url: @station.url, station_name: @station.name).call unless @station.ignore_tracks_from_stream?
    @current_track ||= RadioboxLastTrack.new(url: @station.radio_box_url).call

    Rails.logger.info "#{@station.name} current_track_by: #{@current_track.source} -  #{@current_track}" if @current_track
    Rails.logger.info "#{@station.name} no current_track" unless @current_track

    Rails.cache.write("current_track/#{@station.id}", @current_track)
  end
end
