# frozen_string_literal: true
module HubriseMoney
  module Accessors
    def money_accessor(*attr_names)
      attr_names.each do |attr_name|
        define_method("#{attr_name}_m") do
          send(attr_name) ? HubriseMoney::Money.from_string(send(attr_name)) : nil
        end

        define_method("#{attr_name}_m=") do |v|
          send("#{attr_name}=", v ? v.to_s : nil)
        end
      end
    end
  end
end
