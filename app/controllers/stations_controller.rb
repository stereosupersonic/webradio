class StationsController < ApplicationController
  before_action :set_station, only: %i[show edit update destroy]

  def index
    @stations = StationPresenter.wrap Station.all
  end

  def show
    @station = StationPresenter.new(@station)
  end

  def new
    @station = Station.new
  end

  def edit
  end

  def create
    @station = Station.new(station_params)
    BrowserInfoUpdater.new(station: @station).call
    respond_to do |format|
      if @station.save
        format.html { redirect_to station_url(@station), notice: "Station was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if BrowserInfoUpdater.new(station: @station).call && @station.update(station_params)
        format.html { redirect_to station_url(@station), notice: "Station was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @station.destroy!

    respond_to do |format|
      format.html { redirect_to stations_url, notice: "Station was successfully destroyed." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_station
    @station = Station.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def station_params
    params.require(:station).permit(:name,
      :url,
      :browser_info_byuuid,
      :logo_url,
      :radiobox,
      :position,
      :homepage,
      :ignore_tracks_from_stream,
      :change_track_info_order,
      :locked)
  end
end
