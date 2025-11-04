require "rails_helper"

RSpec.describe ApplicationPresenter do
  let(:test_object) { double("test_object", name: "Test Name") }
  let(:presenter) { described_class.new(test_object) }

  describe "delegation" do
    it "delegates method calls to the wrapped object" do
      expect(presenter.name).to eq("Test Name")
    end
  end

  describe "#object" do
    it "returns the wrapped object" do
      expect(presenter.object).to eq(test_object)
    end
  end

  describe "#o" do
    it "is an alias for object" do
      expect(presenter.o).to eq(test_object)
    end
  end

  describe ".wrap" do
    let(:collection) { [test_object, test_object] }

    it "wraps each element in the collection" do
      wrapped = described_class.wrap(collection)
      expect(wrapped).to all(be_a(ApplicationPresenter))
      expect(wrapped.size).to eq(2)
    end

    it "preserves the wrapped objects" do
      wrapped = described_class.wrap(collection)
      expect(wrapped.map(&:object)).to eq(collection)
    end
  end

  describe "#helpers" do
    it "returns ApplicationController helpers" do
      expect(presenter.helpers).to eq(ApplicationController.helpers)
    end
  end

  describe "#h" do
    it "is an alias for helpers" do
      expect(presenter.h).to eq(presenter.helpers)
    end
  end
end