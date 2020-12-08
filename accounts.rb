# frozen_string_literal: true

require_relative 'lib/bank'
require 'pp'

# Bank data
bank = Bank.new
# pp bank.fetch_accounts
# pp bank.fetch_transactions('40817810200000055320')
bank.accounts_into_file
