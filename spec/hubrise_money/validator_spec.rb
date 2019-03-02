require 'ostruct'

RSpec.describe HubriseMoney::Validator do
  let(:object) { Struct.new(:attr1, :errors) }
  describe ".validate" do
    it "does not assign a error if valid" do
      object = OpenStruct.new(attr1: "-10.00 EUR", errors: {})
      HubriseMoney::Validator.validate(object, :attr1)

      expect(object.errors).to be_empty
    end

    it "assigns a error if invalid" do
      object = OpenStruct.new(attr1: "wrong", errors: {})
      HubriseMoney::Validator.validate(object, :attr1)

      expect(object.errors).to eq(attr1: ["'wrong' is not valid monetary value"])
    end

    it "assigns a error to custom holder" do
      object = OpenStruct.new(attr1: "wrong")
      errors = {}
      HubriseMoney::Validator.validate(object, :attr1, errors: errors)

      expect(errors).to eq(attr1: ["'wrong' is not valid monetary value"])
    end

    it "restricts only positive value" do
      object = OpenStruct.new(attr1: "-10.00 EUR", errors: {})
      HubriseMoney::Validator.validate(object, :attr1, positive: true)

      expect(object.errors).to eq(attr1: ["cannot be below zero"])
    end
  end
end
