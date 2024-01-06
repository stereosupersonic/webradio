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
FactoryBot.define do
  factory :station do
    name { "MyString" }
    url { "MyText" }
  end
end
