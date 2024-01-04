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
require "rails_helper"

RSpec.describe Station, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
