class HubriseMoney::Validator
  class << self
    def validate(record, *fields, errors: record.errors, **options)
      fields.each do |field|
        value = record.public_send(field)

        if error_message = error_message_for(value, **options)
          errors[field] ||= []
          errors[field] << error_message
        end
      end
    end

    def error_message_for(value, positive: false, currency: nil)
      if value
        money = HubriseMoney::Money.from_string(value)
        if positive && money.cents < 0
          return "must be positive ('#{value}' given)"
        end

        if currency && money.currency != currency
          return "must be in '#{currency}' ('#{money.currency}' given)"
        end
      end
  
    rescue HubriseMoney::Money::Error
      "must be a valid monetary value ('#{value}' given)"
    end
  end
end
