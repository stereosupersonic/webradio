require "rails_helper"

RSpec.describe TrackSanitizer do
  it "should handle nil and empty string" do
    expect(described_class.call(text: nil)).to eq("")
    expect(described_class.call(text: " ")).to eq("")
    expect(described_class.call(text: "")).to eq("")
    expect(described_class.call(text: "    ")).to eq("")
  end

  it "should handle umlauts" do
    expect(described_class.call(text: "Österreich")).to eq("Österreich")
  end

  it "should handle invalid" do
    expect(described_class.call(text: "\xfc\xa1\xa1\xa1\xa1\xa1")).to eq("??????")
  end

  it "should handle utf-8" do
    expect(described_class.call(text: "Rondò Veneziano")).to eq("Rondò Veneziano")
  end
end
