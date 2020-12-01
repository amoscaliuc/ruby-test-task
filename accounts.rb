# frozen_string_literal: true

require_relative 'lib/bank'
require 'pp'

# Bank data
bank = Bank.new
# pp bank.fetch_accounts
# pp bank.fetch_transactions
bank.output
