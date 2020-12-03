# frozen_string_literal: true

require '../lib/base'
require '../lib/account'
require '../lib/transaction'

# Test Base Class
RSpec.describe Base do
  def base_entity
    Base.new
  end

  context 'default' do
    it 'accounts' do
      account_hash = Hash.new do |hash, key|
        account = Account.new
        account.name = ''
        account.currency = ''
        account.balance = 0.00
        account.nature = ''
        account.transactions = {}
        hash[key] = account
      end

      expect(base_entity.default_accounts).to eq(account_hash)
    end

    it 'transactions' do
      transaction_hash = Hash.new do |hash, key|
        transaction = Transaction.new
        hash[key] = transaction
      end

      expect(base_entity.default_accounts).to eq(transaction_hash)
    end
  end

  context 'operations' do
    it 'get currency' do
      expect(base_entity.get_currency('10 USD')).to eq('USD')
    end

    it 'get balance' do
      expect(base_entity.get_balance('10 000.00')).to eq('10000.00')
    end
  end
end
