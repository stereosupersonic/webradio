require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  it "is a primary abstract class" do
    expect(ApplicationRecord.primary_abstract_class).to be true
  end
end
