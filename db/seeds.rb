
puts "-------------------"
puts "Seeding stations..."
puts "-------------------"
defaults = {
   name:                      "",
   url:                       "",
   browser_info_byuuid:       "",
   logo_url:                  "",
   radiobox:                  "",
   ignore_tracks_from_stream: false,
   change_track_info_order:   false,
}
yaml = Rails.root.join("db", "stations.yml")
content = ERB.new(File.read(yaml)).result(binding)
records = YAML.safe_load(content) || {}
data = records.values.flatten.map.with_index { |data, i| defaults.merge(data).merge(position: i + 1) }
Station.insert_all(data)

puts "created #{Station.count} stations"
