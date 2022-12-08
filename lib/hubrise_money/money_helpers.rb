# frozen_string_literal: true
module HubriseMoney::SpecHelpers
  def money(amount_s)
    HubriseMoney::Money.from_string(amount_s)
  end
end
