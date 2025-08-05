desc "Update stations from browser info"
task update_stations_from_browser_info: :environment do
  Station.where.not(browser_info_byuuid: nil).where.not(locked: true).find_each do |station|
    BrowserInfoUpdater.new(station: station).call
    station.save!
  end
end

# task reimport: :environment do
#   deleted = Station.delete_all
#   puts "deleted stations #{deleted}"
#   Rake::Task["db:seed"].invoke

#   Rake::Task["update_stations_from_browser_info"].invoke
#   Station.order(:position).each do |station|
#     puts "Station: #{station.name}"
#   end
# end
