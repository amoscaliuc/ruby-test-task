# frozen_string_literal: true

require '../lib/bank'
require '../lib/account'
require '../lib/transaction'
require_relative '../lib/exception/html_empty_error'
require 'nokogiri'

# Test Bank Class
RSpec.describe Bank do
  def bank_entity
    Bank.new
  end

  context 'bank accounts' do
    it 'check count and parse accounts' do
      file = File.open('spec/samples/accounts.html', 'r')
      html = Nokogiri::HTML(file.read)
      accounts = bank_entity.parse_accounts(html)

      expect(accounts.count).to eq(3)
      expect(accounts.first[1]).to be_a Account
      expect(accounts.first[1].name).to eq('40817810200000055320')
      expect(accounts.first[1].currency).to eq('RUB')
      expect(accounts.first[1].balance).to eq(1_000_000.0)
    end

=begin
    it "catch exception" do
      accounts = bank_entity.parse_accounts('')

      expect{ accounts }.to raise_error(HtmlEmptyError)
    end
=end
  end

  context 'account transactions' do
    it 'check count and parse transactions' do
      account = Account.new
      account.name = '40817810200000055320'
      account.currency = 'RUB'
      mock_account = { '40817810200000055320' => account }
      file = File.open('spec/samples/transactions.html', 'r')
      html = Nokogiri::HTML(file.read)
      transactions = bank_entity.parse_transactions(html, mock_account.to_a[0])

      expect(transactions.count).to eq(5)
      expect(transactions.first[1]).to be_a Transaction
      expect(transactions.first[1].account_name).to eq('40817810200000055320')
      expect(transactions.first[1].date).to eq('01.12.2020')
      expect(transactions.first[1].currency).to eq('RUB')
      expect(transactions.first[1].amount).to eq(50.0)
    end
  end
end
