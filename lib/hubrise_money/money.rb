require "hubrise_money/money/currency_data"

class HubriseMoney::Money
  include HubriseMoney::Money::CurrencyData
  class Error < StandardError; end

  # --------------------
  # Accessors
  # --------------------
  attr_reader :cents, :currency

  def zero?
    cents == 0
  end

  def presence
    zero? ? nil : self
  end

  # ------------------------------------
  # Several ways to create Money objects
  # ------------------------------------
  def initialize(a, c = 'EUR')
    raise(Error, "Was expecting a Fixnum as cents, got #{a.inspect} (#{a.class})") if ! (Fixnum === a || Bignum === a)
    raise(Error, "Unknown currency #{c}") if ! CURRENCIES.include?(c)
    @cents, @currency = a, c
  end

  def self.from_string(str)
    if m = str.strip.match(/^ ([-]?) \s* ([0-9]+) (\. ([0-9]{2}))+ \s+ (\S{3})/x)
      sign, digits, _, cents, cur = m[1..5]

      cents << '0' if cents && cents.size == 1

      cents = digits.to_i * 100 + cents.to_i
      cents = -cents if sign == '-'

      new cents, cur
    else
      raise(Error, "Could not convert #{str} to HubriseMoney::Money")
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
      raise(Error, "Expected a String or HubriseMoney::Money, got #{other.inspect} (#{other.class})")
    end
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
    if cents >= 0
      "#{cents / 100}.#{'%02d' % (cents % 100)}"
    else
      "-#{(-cents) / 100}.#{'%02d' % ((-cents) % 100)}"
    end
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
          '-'
        else
          options[:explicit_sign] ? '+' : ''
        end
    locale = (options[:locale] || I18n.locale).to_s
    abs_value =
        if options[:skip_decimals] && (cents % 100) == 0
          (cents / 100).to_s
        else
          "#{cents.abs / 100}.#{'%02d' % (cents.abs % 100)}"
        end

    format =
        case @currency
        when 'CAD' then '%s$ %s'
        when 'CHF' then 'CHF %s%s'
        when 'EUR' then %w{ nl-NL en-IE }.include?(locale) ? '%s€ %s' : '%s%s €'
        when 'GBP' then '%s£ %s'
        when 'UAH' then '%s%s грн'
        when 'RUB' then '%s%s руб'
        when 'USD' then '%s$ %s'
        else "%s%s #{@currency}"
        end
    format.gsub!(' ', '') if options[:compact]
    format % [sign, abs_value]
  end

  # Same as nice_s, with spaces replaced by &nbsp;
  def to_html(options = {})
    self.nice_s(options).gsub(/ /, '&nbsp;').html_safe
  end

  # ----------------------
  # Arithmetic operators
  # ----------------------
  def * other
    if ! [Fixnum, BigDecimal, Float].include?(other.class)
      raise(Error, "Cannot multiply by #{other.inspect} (#{other.class})")
    end
    if other === Float
      self.class.new((cents * other).round, currency)
    else
      self.class.new((cents * other).to_i, currency)
    end
  end

  def / other
    if ! [Fixnum, BigDecimal, Float].include?(other.class)
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
    raise(Error, "Was expecting Fixnum or BigDecimal as divider, got #{other.inspect} (#{other.class})") if ! (Fixnum === other || BigDecimal === other)
    _cents = (cents / other).to_i
    _cents += 1 if options[:round_up] && (_cents * other).to_i < cents
    self.class.new(_cents, currency)
  end

  # Applies a percentage to the price
  # For instance : 3.00 EUR % 90 -> 2.70 EUR
  def % percent
    raise(Error, "Was expecting Fixnum or BigDecimal as operand of %, got #{percent.inspect} (#{percent.class})") if ! (Fixnum === percent || BigDecimal === percent)
    percent_decimal = BigDecimal === percent ? percent : BigDecimal.new(percent.to_s)
    self.class.new((cents * (percent_decimal / 100)).round.to_i, currency)
  end

  def -@
    self.class.new(- cents, currency)
  end

  def - money
    raise(Error, "Was expecting HubriseMoney::Money as operand, got #{money.inspect} (#{money.class})") if ! HubriseMoney::Money === money
    if currency == money.currency
      new_currency = currency
    else
      if money.cents == 0
        new_currency = currency
      elsif cents == 0
        new_currency = money.currency
      else
        raise(Error, 'Incompatible monetary addition on different currencies')
      end
    end
    new_cents = cents - money.cents
    self.class.new(new_cents, new_currency)
  end

  def + money
    raise(Error, "Was expecting Money as operand, got #{money.inspect} (#{money.class})") if ! HubriseMoney::Money === money
    if currency == money.currency
      new_currency = currency
    else
      if money.cents == 0
        new_currency = currency
      elsif cents == 0
        new_currency = money.currency
      else
        raise(Error, 'Incompatible monetary addition on different currencies')
      end
    end
    new_cents = cents + money.cents
    self.class.new(new_cents, new_currency)
  end

  class << self
    def country_to_currency(country_code)
      COUNTRY_TO_CURRENCY[country_code]
    end

    def currency_to_symbol(currency_code)
      CURRENCY_TO_SYMBOL[currency_code]
    end

    def locale_to_currency(locale)
      case locale.to_s
      when 'en-GB'
        'GBP'
      else
        'EUR'
      end
    end
  end
end
