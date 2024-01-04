# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

FactoryBot.create :station, position: 5, name: "Radio Bob", url: "http://streams.radiobob.de/bob-live/mp3-192/mediaplayer"
FactoryBot.create :station, position: 1, name: "Radio Caroline", url: "http://sc6.radiocaroline.net/stream"
FactoryBot.create :station, position: 2, name: "Absolute Radio", url: "http://streams.radiobob.de/bob-live/mp3-192/mediaplayer"
FactoryBot.create :station, position: 3, name: "Radio X", url: "https://media-ssl.musicradio.com/RadioXLondon"
FactoryBot.create :station, position: 4, name: "ROCK ANTENNE Hamburg", url: "http://stream.rockantenne.hamburg/rockantenne-hamburg/stream/mp3"
