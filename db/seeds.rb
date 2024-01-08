# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

FactoryBot.create :station,
  position: 5,
  name: "Radio Bob",
  url: "http://streams.radiobob.de/bob-live/mp3-192/mediaplayer",
  browser_info_byuuid: "92556f58-20d3-44ae-8faa-322ce5f256c0",
  homepage: "https://www.radiobob.de/",
  radiobox: "de/radiobob"

FactoryBot.create :station,
  position: 1,
  name: "Radio Caroline",
  url: "http://sc6.radiocaroline.net/stream",
  browser_info_byuuid: "9606ceae-0601-11e8-ae97-52543be04c81",
  logo_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Radio_Caroline_logo.svg/640px-Radio_Caroline_logo.svg.png",
  radiobox: "uk/radiocaroline"

FactoryBot.create :station,
  position: 2,
  name: "Absolute Radio",
  url: "http://edge-bauerall-01-gos2.sharp-stream.com/absoluteradio.mp3",
  browser_info_byuuid: "39500a4d-5750-4a34-a8c9-d4da0018d322",
  radiobox: "uk/absolute1058"

FactoryBot.create :station,
  position: 3,
  name: "Radio X",
  url: "https://media-ssl.musicradio.com/RadioXLondon",
  browser_info_byuuid: "9617bbd8-0601-11e8-ae97-52543be04c81",
  radiobox: "uk/radiox"

FactoryBot.create :station,
  position: 3,
  name: "XS Manchester",
  url: "https://parg.co/U84n",
  browser_info_byuuid: "35ceded1-e990-4017-b5b4-2e95102a6b41",
  radiobox: "uk/xsmanchester"

FactoryBot.create :station,
  position: 2,
  name: "marilu",
  url: "http://wma01.fluidstream.net/marilu",
  browser_info_byuuid: "9624d45b-0601-11e8-ae97-52543be04c81",
  radiobox: "it/marilu"

FactoryBot.create :station,
  position: 3,
  name: "181.FM - The Eagle (Classic)",
  url: "http://listen.181fm.com/181-eagle_128k.mp3",
  browser_info_byuuid: "a1740fff-dbc9-4efa-b0cb-1fb51e38d3de",
  radiobox: "us/181fmclassic"
