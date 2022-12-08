# frozen_string_literal: true
RSpec.describe(HubriseMoney::Money) do
  describe ".from_string" do
    it "parses the value" do
      value_m = HubriseMoney::Money.from_string("100.50 EUR")
      expect(value_m.cents).to eq(10050)
      expect(value_m.currency).to eq("EUR")
    end

    it "parses the value" do
      value_m = HubriseMoney::Money.from_string("100.00 EUR")
      expect(value_m.cents).to eq(10000)
      expect(value_m.currency).to eq("EUR")
    end

    it "parses negative value" do
      value_m = HubriseMoney::Money.from_string("-100.00 EUR")
      expect(value_m.cents).to eq(-10000)
      expect(value_m.currency).to eq("EUR")
    end

    it "should fail" do
      aggregate_failures do
        [
          "100",
          "100 EUR",
          "100.5 EUR",
          "100.100 EUR",
          "100.10 EURO",
          "+ 100.50 EUR",
        ].each do |invalid_money_string|
          expect { HubriseMoney::Money.from_string(invalid_money_string) }.to raise_error(HubriseMoney::Money::Error), invalid_money_string
        end
      end
    end
  end

  describe "printing" do
    it "prints" do
      expect(HubriseMoney::Money.new(-123, "EUR").to_s).to eq("-1.23 EUR")
    end

    it "converts to BigDecimal" do
      expect(HubriseMoney::Money.new(-123, "EUR").to_d).to eq(BigDecimal("-1.23"))
    end

    it "converts to float" do
      expect(HubriseMoney::Money.new(-123, "EUR").to_f).to be_within(0.001).of(-1.23)
    end
  end

  describe ".country_to_currency" do
    it "returns currency" do
      expect(HubriseMoney::Money.country_to_currency("TW")).to eq("TWD")
    end
  end

  describe ".currency_to_symbol" do
    it "returns symbol" do
      expect(HubriseMoney::Money.currency_to_symbol("TWD")).to eq("$")
    end
  end

  describe "#initialize" do
    it "builds an object" do
      expect(HubriseMoney::Money.new(100).to_s).to eq("1.00 EUR")
    end

    it "builds an object with a warning when the currency is not specified" do
      expect { HubriseMoney::Money.new(100).to_s }.to output.to_stdout
    end

    it "fails with wrong type" do
      expect { HubriseMoney::Money.new("100") }.to raise_error(HubriseMoney::Money::Error)
    end
  end

  describe "#*" do
    it "multiplies" do
      new_money = HubriseMoney::Money.new(100, "EUR") * 2
      expect(new_money.to_s).to eq("2.00 EUR")
    end

    it "fails with wrong type" do
      expect { HubriseMoney::Money.new(100, "EUR") * "2" }.to raise_error(HubriseMoney::Money::Error)
    end
  end

  describe "#/" do
    it "divides" do
      new_money = HubriseMoney::Money.new(100, "EUR") / 2
      expect(new_money.to_s).to eq("0.50 EUR")
    end

    it "fails with wrong type" do
      expect { HubriseMoney::Money.new(100, "EUR") / "2" }.to raise_error(HubriseMoney::Money::Error)
    end
  end

  describe "#div" do
    it "divides" do
      new_money = HubriseMoney::Money.new(100, "EUR").div(2)
      expect(new_money.to_s).to eq("0.50 EUR")
    end

    it "fails with wrong type" do
      expect { HubriseMoney::Money.new(100, "EUR").div("2") }.to raise_error(HubriseMoney::Money::Error)
    end
  end

  describe "#%" do
    it "returns a percentage" do
      new_money = HubriseMoney::Money.new(100, "EUR") % 2
      expect(new_money.to_s).to eq("0.02 EUR")
    end

    it "fails with wrong type" do
      expect { HubriseMoney::Money.new(100, "EUR") % "2" }.to raise_error(HubriseMoney::Money::Error)
    end
  end

  describe "#-" do
    it "returns a difference" do
      new_money = HubriseMoney::Money.new(100, "EUR") - HubriseMoney::Money.new(40, "EUR")
      expect(new_money.to_s).to eq("0.60 EUR")
    end

    it "fails with wrong type" do
      expect { HubriseMoney::Money.new(100, "EUR") - "2" }.to raise_error(HubriseMoney::Money::Error)
    end
  end

  describe "#presence" do
    it "returns nil on zero money" do
      expect(HubriseMoney::Money.new(0, "EUR").presence).to be_nil
    end

    it "returns self on non-zero money" do
      money = HubriseMoney::Money.new(100, "EUR")
      expect(money.presence).to eq(money)
    end
  end

  describe "#present?" do
    it "is not present on zero money" do
      expect(HubriseMoney::Money.new(0, "EUR")).to_not(be_present)
    end

    it "is present on non-zero money" do
      expect(HubriseMoney::Money.new(100, "EUR")).to be_present
    end
  end

  describe "sign accessors" do
    it "is positive on positive money" do
      expect(HubriseMoney::Money.new(100, "EUR").positive?).to be_truthy
      expect(HubriseMoney::Money.new(-100, "EUR").positive?).to be_falsey
    end

    it "is negative on negative money" do
      expect(HubriseMoney::Money.new(100, "EUR").negative?).to be_falsey
      expect(HubriseMoney::Money.new(-100, "EUR").negative?).to be_truthy
    end
  end
end
