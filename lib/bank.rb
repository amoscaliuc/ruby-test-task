# frozen_string_literal: true

require 'rubygems'
require 'watir'
require 'nokogiri'
require 'date'
require_relative 'base'
require_relative 'exception/account_empty_error'
require_relative 'exception/transaction_empty_error'
require_relative 'exception/html_empty_error'

# Nokogiri implementation
class Bank < Base
  def connect
    Watir::Browser.new
  end

  def fetch_accounts
    browser = connect
    browser.goto 'https://demo.bank-on-line.ru'
    browser.div(class: 'button-demo').click
    browser.goto 'https://demo.bank-on-line.ru/#Contracts'
    html = Nokogiri::HTML.fragment(browser.table(id: 'contracts-list').html)
    parse_accounts(html)
  end

  def parse_accounts(html)
    raise HtmlEmptyError, 'Empty html!' if html == ''

    table_rows = html.css('tr.cp-item')
    text_all_rows = table_rows.map do |row|
      row_values = row.css("td[data-action='show-contract-info']").map(&:text)
      row_values.reject(&:empty?)
    end

    raise AccountEmptyError, 'No accounts detected!' if text_all_rows == []

    accounts = []
    text_all_rows.each_with_index do |account, index|
      new_account = Account.new(
        name: account[0],
        currency: get_currency(account[1]),
        balance: get_balance(account[3]).to_f,
        nature: account[2]
      )
      accounts[index] = to_hash(new_account)
    end

    accounts
  end

  def fetch_transactions(account_name)
    browser = connect
    browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_name}/Transactions"
    browser.div(class: 'button-demo').click
    browser.text_field(id: 'DateFrom').click
    browser.span(class: 'ui-icon-circle-triangle-w').click
    browser.a(class: 'ui-state-default', text: Date.today.strftime('%d').sub!(/^0/, '')).click
    browser.span(id: 'getTranz').click
    html = Nokogiri::HTML.fragment(browser.table(class: 'cp-tran-with-balance').html)
    parse_transactions(html, account_name)
  end

  def parse_transactions(html, account_name)
    raise HtmlEmptyError, 'Empty html!' if html == ''

    table_rows = html.css('tr.cp-transaction')
    text_all_rows = table_rows.map do |row|
      row_values = row.css("td[data-action='transaction-show-details']").map(&:text)
      row_values.reject(&:empty?)
    end

    raise TransactionEmptyError, 'No transactions detected!' if text_all_rows == []

    transactions = []
    text_all_rows.each_with_index do |transaction, index|
      new_transaction = Transaction.new(
        date: transaction[3],
        description: transaction[2],
        amount: get_balance(transaction[4]).to_f,
        currency: get_transaction_currency(transaction[2]),
        account_name: account_name
      )
      transactions[index] = to_hash(new_transaction)
    end

    transactions
  end

  def accounts_into_file
    File.open('output.json', 'w') do |file|
      accounts = fetch_accounts.each do |account|
        account['transactions'] = fetch_transactions(account['name'])
      end

      file.write(JSON.pretty_generate({ 'accounts' => accounts }))
    end
  end
end
