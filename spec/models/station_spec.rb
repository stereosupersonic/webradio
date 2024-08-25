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
require "rails_helper"

RSpec.describe Station, type: :model do
  it 'is valid with valid attributes' do
    station = build(:station)
    expect(station).to be_valid
  end

  it 'is not valid without a url' do
    station = build(:station, url: nil)
    expect(station).not_to be_valid
  end

  it 'is not valid without a name' do
    station = build(:station, name: nil)
    expect(station).not_to be_valid
  end

  it 'returns the correct logo url' do
    station = build(:station, logo_url: 'logo.png')
    expect(station.logo_url).to eq('logo.png')
  end
end
