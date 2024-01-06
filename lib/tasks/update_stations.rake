desc "Update stations from browser info"
task update_stations_from_browser_info: :environment do
  Station.where.not(browser_info_byuuid: nil).each do |station|
    BrowserInfoUpdater.new(station:).call
  end
end
