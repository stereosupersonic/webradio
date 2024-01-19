class ChangeArtistTrackToStations < ActiveRecord::Migration[7.1]
  def change
    add_column :stations, :change_track_info_order, :boolean, default: false, null: false
  end
end
