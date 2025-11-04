require "rails_helper"

RSpec.describe BaseService do
  let(:test_service_class) do
    Class.new(BaseService) do
      attr_accessor :test_param

      def call
        "service called with #{test_param}"
      end
    end
  end

  describe ".call" do
    it "creates new instance and calls #call" do
      result = test_service_class.call(test_param: "test_value")
      expect(result).to eq("service called with test_value")
    end

    it "works without arguments" do
      result = test_service_class.call
      expect(result).to eq("service called with ")
    end
  end

  describe ".call!" do
    it "creates new instance and calls #call!" do
      service_instance = test_service_class.new(test_param: "test_value")
      expect(test_service_class).to receive(:new).and_return(service_instance)
      expect(service_instance).to receive(:call!)

      test_service_class.call!(test_param: "test_value")
    end
  end

  describe "#call!" do
    it "validates before calling" do
      service = test_service_class.new(test_param: "test_value")
      expect(service).to receive(:validate!)
      expect(service).to receive(:call)

      service.call!
    end
  end

  describe "#call" do
    it "has empty default implementation" do
      service = BaseService.new
      expect(service.call).to be_nil
    end
  end
end