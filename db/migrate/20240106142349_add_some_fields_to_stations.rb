class AddSomeFieldsToStations < ActiveRecord::Migration[7.1]
  def change
    add_column :stations, :description, :text
    add_column :stations, :country, :string
    add_column :stations, :browser_info_byuuid, :string
    add_column :stations, :logo_url, :text
  end
end
