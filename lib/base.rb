# frozen_string_literal: true

require 'watir'
require_relative 'account'
require_relative 'transaction'
require 'date'

# Base class with common methods
class Base
  def default_accounts
    Hash.new do |hash, key|
      account = Account.new
      account.name = ''
      account.currency = ''
      account.balance = 0.00
      account.nature = ''
      account.transactions = {}
      hash[key] = account
    end
  end

  def default_transactions
    Hash.new do |hash, key|
      transaction = Transaction.new
      hash[key] = transaction
    end
  end

  def get_currency(string)
    result = string.split(' ')
    result[1] || '-'
  end

  def get_balance(string)
    format '%.2f', string.delete(' ').to_f
  rescue ArgumentError
    nil
  end
end
