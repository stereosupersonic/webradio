class AddIgnoreTracksFromStreamToStations < ActiveRecord::Migration[7.1]
  def change
    add_column :stations, :ignore_tracks_from_stream, :boolean, default: false, null: false
  end
end
