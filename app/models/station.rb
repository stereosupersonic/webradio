# == Schema Information
#
# Table name: stations
#
#  id                  :bigint           not null, primary key
#  browser_info_byuuid :string
#  country             :string
#  description         :text
#  homepage            :string
#  logo_url            :text
#  name                :string
#  position            :integer          default(100)
#  url                 :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_stations_on_position  (position)
#
class Station < ApplicationRecord
  def self.create_by_browser_info(byuuid)
    return if byuuid.blank?

    station = Station.new browser_info_byuuid: byuuid, postion: Station.count + 1
    BrowserInfoUpdater.new(station:).call
  end
end
