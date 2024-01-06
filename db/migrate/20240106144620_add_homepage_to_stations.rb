class AddHomepageToStations < ActiveRecord::Migration[7.1]
  def change
    add_column :stations, :homepage, :string
  end
end
