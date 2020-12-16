# frozen_string_literal: true

# Account class
class Account
  attr_accessor :name, :currency, :balance, :nature, :transactions

  def initialize(name:, currency:, balance:, nature:, transactions: {})
    self.name = name
    self.currency = currency
    self.balance = balance
    self.nature = nature
    self.transactions = transactions
  end
end
