class AddLockedToStations < ActiveRecord::Migration[8.0]
  def change
    add_column :stations, :locked, :boolean, default: false, null: false
  end
end
