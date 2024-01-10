# == Schema Information
#
# Table name: stations
#
#  id                        :bigint           not null, primary key
#  browser_info_byuuid       :string
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
class Station < ApplicationRecord
  validates :url, presence: true
  validates :name, presence: true

  scope :ordered, -> { order(position: :asc) }

  def self.create_by_browser_info(byuuid)
    return if byuuid.blank?

    station = Station.new browser_info_byuuid: byuuid, position: Station.count + 1
    BrowserInfoUpdater.new(station: station).call
    station.save!
  end
end
