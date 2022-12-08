# frozen_string_literal: true
require "hubrise_money/money/currency_data"
require "bigdecimal"

module HubriseMoney
  class Money
    include HubriseMoney::Money::CurrencyData

    class Error < StandardError; end

    # --------------------
    # Accessors
    # --------------------
    attr_reader :cents, :currency

    def zero?
      cents == 0
    end

    def present?
      !zero?
    end

    def presence
      present? ? self : nil
    end

    def positive?
      cents >= 0
    end

    def negative?
      !positive?
    end

    # ------------------------------------
    # Several ways to create Money objects
    # ------------------------------------
    def initialize(cents, currency = nil)
      unless cents.is_a?(Integer)
        raise(Error, "Was expecting an Integer as cents, got #{cents.inspect} (#{cents.class})")
      end

      unless currency
        puts "Calling the constructor without an explicit currency is deprecated." \
              " Defaulting to EUR for backwards compatibility."
        currency = "EUR"
      end
      raise(Error, "Unknown currency #{currency}") unless CURRENCIES.include?(currency)

      @cents = cents
      @currency = currency
    end

    def self.from_string(str)
      match = str.strip.match(regexp)
      if match
        sign, digits, _, cents, cur = match[1..5]

        cents << "0" if cents && cents.size == 1

        cents = digits.to_i * 100 + cents.to_i
        cents = -cents if sign == "-"

        new(cents, cur)
      else
        raise(Error, "Could not convert #{str} to HubriseMoney::Money")
      end
    end

    # other is either another Money or a string ('EUR', '15.4 EUR', ...)
    def self.null_money(other)
      if other.is_a?(Money)
        new(0, other.currency)
      elsif other.is_a?(String)
        other =~ /(\w{3})$/ && currency = Regexp.last_match(1)
        new(0, currency)
      else
        raise(Error, "Expected a String or HubriseMoney::Money, got #{other.inspect} (#{other.class})")
      end
    end

    def self.regexp(positive_only: false)
      sign_regexp = positive_only ? "" : "([-]?)"
      /^ #{sign_regexp} \s* ([0-9]+) (\. ([0-9]{2}))+ \s+ (\S{3}) \z/x
    end

    # --------------------
    # Comparison operators
    # --------------------
    def <=>(other)
      raise(Error, "Cannot compare moneys with different currencies: #{self} ** #{other}") if currency != other.currency
      cents <=> other.cents
    end

    include Comparable # Define <, <=, >, >=, == from the method above

    def ==(other)
      other.is_a?(Money) && cents == other.cents && currency == other.currency
    end

    # ---------------------
    # Printing methods
    # ---------------------
    # Example result: "-10.40 EUR"
    def to_s
      "#{to_s_no_currency} #{currency}"
    end

    # Example result: "-10.40" (for -10.40 EUR)
    def to_s_no_currency
      if cents >= 0
        "#{cents / 100}.#{format('%02d', (cents % 100))}"
      else
        "-#{(-cents) / 100}.#{format('%02d', ((-cents) % 100))}"
      end
    end

    # Example result: -10.40 (as a BigDecimal)
    def to_d
      BigDecimal(to_s_no_currency)
    end

    # This method is useful to encode a numeric value in JSON, eg: `amount_m.to_f.to_json`
    # Example result: -10.4 (as a float)
    def to_f
      to_s_no_currency.to_f
    end

    # Return something like "10.40 €", "-$3.50", ...
    # options
    #   - :explicit_sign -> prefix with '+' sign for positive values
    #   - :compact -> no space
    #   - :locale -> supersedes I18n.locale
    #   - :skip_decimals -> skips decimals for round values
    def nice_s(options = {})
      sign =
        if @cents < 0
          "-"
        else
          options[:explicit_sign] ? "+" : ""
        end
      locale = (options[:locale] || I18n.locale).to_s
      abs_value =
        if options[:skip_decimals] && (cents % 100) == 0
          (cents / 100).to_s
        else
          "#{cents.abs / 100}.#{format('%02d', (cents.abs % 100))}"
        end

      format =
        case @currency
        when "CAD" then "%s$ %s"
        when "CHF" then "CHF %s%s"
        when "EUR" then %w{nl-NL en-IE}.include?(locale) ? "%s€ %s" : "%s%s €"
        when "GBP" then "%s£ %s"
        when "UAH" then "%s%s грн"
        when "RUB" then "%s%s руб"
        when "USD" then "%s$ %s"
        else "%s%s #{@currency}"
        end
      format.gsub!(" ", "") if options[:compact]
      format(format, sign, abs_value)
    end

    # Same as nice_s, with spaces replaced by &nbsp;
    def to_html(options = {})
      nice_s(options).gsub(/ /, "&nbsp;").html_safe
    end

    # ----------------------
    # Arithmetic operators
    # ----------------------
    def *(other)
      unless other.is_a?(Numeric)
        raise(Error, "Cannot multiply by #{other.inspect} (#{other.class})")
      end

      if other.is_a?(Float)
        self.class.new((cents * other).round, currency)
      else
        self.class.new((cents * other).to_i, currency)
      end
    end

    def /(other)
      unless other.is_a?(Numeric)
        raise(Error, "Cannot divide by #{other.inspect} (#{other.class})")
      end

      if other.is_a?(Float)
        self.class.new((cents / other).round, currency)
      else
        self.class.new((cents / other).to_i, currency)
      end
    end

    # Division with options:
    #  - :round_up -> makes split cent round up to upper cent instead of lower by default
    def div(other, options = {})
      unless other.is_a?(Numeric)
        raise(Error, "Was expecting Numeric as divider, got #{other.inspect} (#{other.class})")
      end

      new_cents = (cents / other).to_i
      new_cents += 1 if options[:round_up] && (new_cents * other).to_i < cents
      self.class.new(new_cents, currency)
    end

    # Applies a percentage to the price
    # For instance : 3.00 EUR % 90 -> 2.70 EUR
    def %(other)
      unless other.is_a?(Numeric)
        raise(Error, "Was expecting Numeric as operand of %, got #{other.inspect} (#{other.class})")
      end

      percent_decimal = other.is_a?(BigDecimal) ? other : BigDecimal(other.to_s)
      self.class.new((cents * (percent_decimal / 100)).round.to_i, currency)
    end

    def -@
      self.class.new(-cents, currency)
    end

    def +(other)
      unless other.is_a?(HubriseMoney::Money)
        raise(Error, "Was expecting Money as operand, got #{other.inspect} (#{other.class})")
      end

      if currency == other.currency
        new_currency = currency
      elsif other.cents == 0
        new_currency = currency
      elsif cents == 0
        new_currency = other.currency
      else
        raise(Error, "Incompatible monetary addition on different currencies")
      end

      self.class.new(cents + other.cents, new_currency)
    end

    def -(other)
      self + -other
    end

    def self.country_to_currency(country_code)
      COUNTRY_TO_CURRENCY[country_code]
    end

    def self.currency_to_symbol(currency_code)
      CURRENCY_TO_SYMBOL[currency_code]
    end
  end
end
