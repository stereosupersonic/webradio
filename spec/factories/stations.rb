# == Schema Information
#
# Table name: stations
#
#  id                        :bigint           not null, primary key
#  browser_info_byuuid       :string
#  change_track_info_order   :boolean          default(FALSE), not null
#  country                   :string
#  description               :text
#  homepage                  :string
#  ignore_tracks_from_stream :boolean          default(FALSE), not null
#  logo_url                  :text
#  name                      :string
#  position                  :integer          default(100)
#  radiobox                  :string
#  url                       :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_stations_on_position  (position)
#
FactoryBot.define do
  factory :station do
    name { "Radio Caroline" }
    position { 1 }
    url { "http://78.129.202.200:8040" }
    browser_info_byuuid { "9606ceae-0601-11e8-ae97-52543be04c81" }
    logo_url { "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Radio_Caroline_logo.svg/640px-Radio_Caroline_logo.svg.png" }
    radiobox { "uk/radiocaroline" }
  end
end
