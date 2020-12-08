# frozen_string_literal: true

require_relative 'lib/bank'

# Bank data
bank = Bank.new
# puts bank.fetch_accounts
# puts bank.fetch_transactions('40817810200000055320')
bank.accounts_into_file
