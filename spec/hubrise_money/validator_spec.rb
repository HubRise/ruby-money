# frozen_string_literal: true
require "ostruct"

RSpec.describe(HubriseMoney::Validator) do
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

      expect(object.errors).to eq(attr1: ["must be a valid monetary value ('wrong' given)"])
    end

    it "assigns a error to custom holder" do
      object = OpenStruct.new(attr1: "wrong")
      errors = {}
      HubriseMoney::Validator.validate(object, :attr1, errors: errors)

      expect(errors).to eq(attr1: ["must be a valid monetary value ('wrong' given)"])
    end

    it "restricts only positive value" do
      object = OpenStruct.new(attr1: "-10.00 EUR", attr2: "10.00 EUR", errors: {})
      HubriseMoney::Validator.validate(object, :attr1, :attr2, positive: true)

      expect(object.errors).to eq(attr1: ["must be positive ('-10.00 EUR' given)"])
    end

    it "restricts min_cents value" do
      object = OpenStruct.new(attr1: "-10.00 EUR", attr2: "10.00 EUR", errors: {})
      HubriseMoney::Validator.validate(object, :attr1, :attr2, min_cents: 1000)

      expect(object.errors).to eq(attr1: ["must be greater than or equal to 10.00 EUR"])
    end

    it "restricts on currency value" do
      object = OpenStruct.new(attr1: "10.00 EUR", attr2: "10.00 USD", errors: {})
      HubriseMoney::Validator.validate(object, :attr1, :attr2, currency: "EUR")

      expect(object.errors).to eq(attr2: ["must be in 'EUR' ('USD' given)"])
    end
  end
end
