# frozen_string_literal: true

class Transaction
  attr_accessor :date, :description, :amount, :currency, :account_name

  def initialize(date:, description:, amount:, currency:, account_name:)
    self.date = date
    self.description = description
    self.amount = amount
    self.currency = currency
    self.account_name = account_name
  end
end
