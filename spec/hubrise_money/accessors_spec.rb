RSpec.describe HubriseMoney::Accessors do
  describe ".money_accessor" do
    subject do
      Struct.new(:attr1, :attr2) do
        extend HubriseMoney::Accessors
        money_accessor :attr1, :attr2
      end
    end

    describe "attr_m accessor" do
      it "it returns money object" do
        object = subject.new("10.00 EUR", "20.00 USD")
        aggregate_failures do
          expect(object.attr1_m).to eq(HubriseMoney::Money.new(1000, "EUR"))
          expect(object.attr2_m).to eq(HubriseMoney::Money.new(2000, "USD"))
        end
      end

      it "returns nil for nil raw value" do
        expect(subject.new(nil).attr1_m).to be_nil
      end

      it "raises error for unparsable raw value" do
        expect { subject.new("wrong").attr1_m }.to raise_error(HubriseMoney::Money::Error)
      end
    end

    describe "attr_m= accessor" do
      it "assigns stringified value" do
        object = subject.new
        object.attr1_m = HubriseMoney::Money.new(2000, "EUR")
        object.attr2_m = HubriseMoney::Money.new(1000, "USD")

        aggregate_failures do
          expect(object.attr1).to eq("20.00 EUR")
          expect(object.attr2).to eq("10.00 USD")
        end
      end

      it "nilifies raw value if nil assigned" do
        object = subject.new("val1")
        object.attr1_m = nil

        expect(object.attr1).to eq(nil)
      end
    end
  end
end
