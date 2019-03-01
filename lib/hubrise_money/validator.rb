class HubriseMoney::Validator
  class << self
    def validate(record, *fields, **options)
      fields.each do |field|
        value = record.public_send(field)

        if error_message = error_message_for(value, **options)
          record.errors[field] << error_message
        end
      end
    end

    def error_message_for(value, positive: false)
      if value
        money = HubriseMoney::Money.from_string(value)
        if positive && money.cents < 0
          "cannot be below zero"
        end
      end
  
    rescue HubriseMoney::Money::Error
      "'#{value}' is not valid monetary value"
    end
  end
end
