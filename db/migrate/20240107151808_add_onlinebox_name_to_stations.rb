class AddOnlineboxNameToStations < ActiveRecord::Migration[7.1]
  def change
    add_column :stations, :radiobox, :string
  end
end
