module HubriseMoney
  module Accessors
    def money_accessor(*ids)
      __money_accessor(*ids, nil)
    end

    def money_accessor_with_suffix(*ids)
      __money_accessor(*ids, 'm')
    end

    def __money_accessor(*ids, suffix)
      for id in ids
        module_eval <<-"end_eval"
      validate do
        Hubrise::Money.validate(errors, :#{id.to_s}, self[:#{id.to_s}])
      end

      def #{id.to_s}#{suffix ? '_' + suffix : ''}
        self[:#{id.to_s}] ? Hubrise::Money.from_string(self[:#{id.to_s}]) : nil
      end

      def #{id.to_s}#{suffix ? '_' + suffix : ''}=(v)
        self[:#{id.to_s}] = (v ? v.to_s : nil)
      end
        end_eval
      end
    end
  end
end
