# == Schema Information
#
# Table name: stations
#
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer          default(100)
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
