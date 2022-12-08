# frozen_string_literal: true
module HubriseMoney
  class Validator
    class << self
      def validate(record, *fields, errors: record.errors, **options)
        fields.each do |field|
          value = record.public_send(field)
          error_message = error_message_for(value, **options)

          if error_message
            if errors.respond_to?(:add)
              errors.add(field, error_message)
            else
              errors[field] ||= []
              errors[field] << error_message
            end
          end
        end
      end

      def error_message_for(value, positive: false, currency: nil, min_cents: nil)
        if value
          money = HubriseMoney::Money.from_string(value)
          if positive && money.cents < 0
            return "must be positive ('#{value}' given)"
          end

          if min_cents && money.cents < min_cents
            return "must be greater than or equal to " + HubriseMoney::Money.new(min_cents, money.currency).to_s
          end

          if currency && money.currency != currency
            "must be in '#{currency}' ('#{money.currency}' given)"
          end
        end
      rescue HubriseMoney::Money::Error
        "must be a valid monetary value ('#{value}' given)"
      end
    end
  end
end
