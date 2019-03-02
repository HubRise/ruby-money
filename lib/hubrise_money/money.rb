module HubriseMoney
  class Money
    class Error < StandardError; end

    private

    CURRENCY_WITH_OPTIONS = {
        'AED' => { format: '%s%s AED', separator: '.', symbol: 'DH' },
        'BGN' => { format: '%s%s лв', separator: '.', symbol: 'лв' },
        'BRL' => { format: '%sR$ %s', separator: ',', symbol: 'R$' },
        'CAD' => { format: '%s$ %s', separator: '.', symbol: '$' },
        'CHF' => { format: 'CHF %s%s', separator: '.', symbol: 'Fr.' },
        'EUR' => { format: -> (locale) { %w{ nl-NL en-IE }.include?(locale) ? '%s€ %s' : '%s%s €' }, separator: '.', symbol: '€' },
        'GBP' => { format: '%s£ %s', separator: '.', symbol: '£' },
        'ISK' => { format: '%skr %s', separator: nil, symbol: 'kr' },
        'MAD' => { format: '%s%s DH', separator: '.', symbol: 'DH' },
        'PKR' => { format: '%sRs. %s', separator: nil, symbol: 'Rs.' },
        'RUB' => { format: '%s%s руб', separator: '.', symbol: 'руб' },
        'TND' => { format: '%s%s DT', separator: '.', symbol: 'TD' },
        'UAH' => { format: '%s%s грн', separator: '.', symbol: 'грн' },
        'USD' => { format: '%s$ %s', separator: '.', symbol: '$' },
        'ZAR' => { format: '%sR%s', separator: '.', symbol: 'R' },
    }

    public

    CURRENCIES = CURRENCY_WITH_OPTIONS.keys

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

    # ------------------------------------
    # Several ways to create Money objects
    # ------------------------------------

    # Takes a Fixnum/Bignum
    #   (150, 'EUR') -> Money('1.50 EUR')
    def initialize(cents, currency = 'EUR')
      raise Error, "Invalid type: #{cents.inspect} (#{cents.class})" if ![Fixnum, Bignum].include?(cents.class)
      raise Error, "Unknown currency #{currency}" if !CURRENCIES.include?(currency)
      @cents, @currency = cents, currency
    end

    def self.from_string(str)
      if m = str.strip.match(/^ ([-]?) \s* ([0-9]+) (\. ([0-9]{2}))+ \s+ (\S{3})/x)
        sign, digits, _, cents, cur = m[1..5]

        cents << '0' if cents && cents.size == 1

        cents = digits.to_i * 100 + cents.to_i
        cents = -cents if sign == '-'

        new(cents, cur)
      else
        raise Error, "Could not convert #{str} to HubriseMoney::Money"
      end
    end

    # Takes a Fixnum/Bignum, BigDecimal, String or nil
    #   ('1.50', 'EUR') -> Money('1.50 EUR')
    #   (10, 'EUR') -> Money('10.00 EUR')
    #   nil -> nil
    def self.from_number_and_currency(number, currency)
      raise Error, "Invalid type: #{number.inspect} (#{number.class})" if ![Fixnum, Bignum, String, BigDecimal, NilClass].include?(number.class)
      raise Error, "Unknown currency #{currency}" if !CURRENCIES.include?(currency)
      if number.present?
        # Remove non numeric chars
        str = number.to_s.gsub(/[^0-9\.\-]/, '')
        new((str.to_d * 100).to_i, currency)
      end
    end

    # other is either another Money or a string ('EUR', '15.4 EUR', ...)
    def self.null_money(other)
      if self === other
        new(0, other.currency)
      elsif String === other
        other =~ /(\w{3})$/ && currency = $1
        new(0, currency)
      else
        raise Error, "Expected a String or HubriseMoney::Money, got #{other.inspect} (#{other.class})"
      end
    end

    # --------------------
    # Comparison operators
    # --------------------
    def <=>(other)
      raise Error, "Cannot compare moneys with different currencies: #{self} ** #{other}" if currency != other.currency
      cents <=> other.cents
    end

    include Comparable # Defines <, <=, >, >=, == from the method above

    def ==(other)
      self.class === other && cents == other.cents && currency == other.currency
    end

    # ---------------------
    # Printing methods
    # ---------------------
    # Returns something like "-10.40 EUR"
    def to_s
      "#{to_s_no_currency} #{currency}"
    end

    # Return something like "-10.40" (for -10.40 EUR)
    def to_s_no_currency
      sign = cents >= 0 ? '' : '-'

      integral_part = "#{sign}#{cents.abs / 100}"
      decimal_part  = '%02d' % (cents.abs % 100)

      [integral_part, decimal_part].join('.')
    end

    # Return something like "10.40 €", "-$3.50", ...
    # options
    #   - :explicit_sign -> prefix with '+' sign for positive values
    #   - :compact -> no space
    #   - :locale -> supersedes I18n.locale
    def nice_s(options = {})
      sign   =
          if @cents < 0
            '-'
          else
            options[:explicit_sign] ? '+' : ''
          end
      locale = (options[:locale] || I18n.locale).to_s

      format, cents_separator =
          CURRENCY_WITH_OPTIONS[@currency].values_at(:format, :separator).
              map { |x| Proc === x ? x.call(locale) : x }

      abs_value =
          if cents_separator
            [(cents.abs / 100).to_s, cents_separator, '%02d' % (cents.abs % 100)].join
          else
            ((cents.abs + 50) / 100).to_s
          end

      format.gsub!(' ', '') if options[:compact]
      format % [sign, abs_value]
    end

    # Same as nice_s, with spaces replaced by &nbsp;
    def to_html(options = {})
      self.nice_s(options).gsub(/ /, '&nbsp;').html_safe
    end

    def self.iso_to_symbol(currency)
      CURRENCY_WITH_OPTIONS[currency][:symbol]
    end

    def self.is_prefix(locale)
      ['en-GB', 'en-IE', 'en-US', 'is-IS', 'nl-NL', 'en-ZA'].include?(locale)
    end

    # ----------------------
    # Arithmetic operators
    # ----------------------
    def * other
      if ![Fixnum, Bignum, BigDecimal, Float].include?(other.class)
        raise Error, "Cannot multiply by #{other.inspect} (#{other.class})"
      end
      if other === Float
        self.class.new((cents * other).round, currency)
      else
        self.class.new((cents * other).to_i, currency)
      end
    end

    def / other
      if ![Fixnum, Bignum, BigDecimal, Float].include?(other.class)
        "Cannot divide by #{other.inspect} (#{other.class})"
      end
      if other === Float
        self.class.new((cents / other).round, currency)
      else
        self.class.new((cents / other).to_i, currency)
      end
    end

    # Division with options:
    #  - :round_up -> makes split cent round up to upper cent instead of lower by default
    def div(other, options = {})
      raise Error, "Was expecting a Fixnum, Bignum or BigDecimal as divider, got #{other.inspect} (#{other.class})" if ![Fixnum, Bignum, BigDecimal].include?(other.class)
      _cents = (cents / other).to_i
      _cents += 1 if options[:round_up] && (_cents * other).to_i < cents
      self.class.new(_cents, currency)
    end

    # Applies a percentage to the price
    # For instance : 3.00 EUR % 90 -> 2.70 EUR
    def % percent
      raise Error, "Was expecting a Fixnum, Bignum or BigDecimal as operand of %, got #{percent.inspect} (#{percent.class})" if ![Fixnum, Bignum, BigDecimal].include?(percent.class)
      self.class.new((cents * (BigDecimal(percent) / 100)).round.to_i, currency)
    end

    def -@
      self.class.new(-cents, currency)
    end

    def - money
      raise Error, "Was expecting Money as operand, got #{money.inspect} (#{money.class})" if !(Money === money)
      if currency == money.currency
        new_currency = currency
      else
        if money.cents == 0
          new_currency = currency
        elsif cents == 0
          new_currency = money.currency
        else
          raise Error, 'Incompatible monetary addition on different currencies'
        end
      end
      new_cents = cents - money.cents
      self.class.new(new_cents, new_currency)
    end

    def + money
      raise Error, "Was expecting Money as operand, got #{money.inspect} (#{money.class})" if !(Money === money)
      if currency == money.currency
        new_currency = currency
      else
        if money.cents == 0
          new_currency = currency
        elsif cents == 0
          new_currency = money.currency
        else
          raise Error, 'Incompatible monetary addition on different currencies'
        end
      end
      new_cents = cents + money.cents
      self.class.new(new_cents, new_currency)
    end
  end
end
