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
  def browser
    Watir::Browser.new
  end

  def fetch_accounts(browser)
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

    accounts = default_accounts
    text_all_rows.each do |account|
      account_number = account[0]
      accounts[account_number].name = account_number
      accounts[account_number].currency = get_currency(account[1])
      accounts[account_number].balance = get_balance(account[3]).to_f
      accounts[account_number].nature = account[2]
    end

    accounts
  end

  def fetch_transactions(browser)
    accounts = fetch_accounts(browser)
    accounts.each do |account|
      account_name = account[1].name
      browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_name}/Transactions"
      browser.text_field(id: 'DateFrom').click
      browser.span(class: 'ui-icon-circle-triangle-w').click
      browser.a(class: 'ui-state-default', text: Date.today.strftime('%d').sub!(/^0/, '')).click
      browser.span(id: 'getTranz').click
      html = Nokogiri::HTML.fragment(browser.table(class: 'cp-tran-with-balance').html)
      accounts[account_name].transactions = parse_transactions(html, account)
    end

    accounts
  end

  def parse_transactions(html, account)
    raise HtmlEmptyError, 'Empty html!' if html == ''

    table_rows = html.css('tr.cp-transaction')
    text_all_rows = table_rows.map do |row|
      row_values = row.css("td[data-action='transaction-show-details']").map(&:text)
      row_values.reject(&:empty?)
    end

    raise TransactionEmptyError, 'No transactions detected!' if text_all_rows == []

    count = 0
    transactions = default_transactions
    text_all_rows.each do |transaction|
      transactions[count].date = transaction[3]
      transactions[count].description = transaction[2]
      transactions[count].amount = get_balance(transaction[4]).to_f
      transactions[count].currency = account[1].currency
      transactions[count].account_name = account[1].name
      count += 1
    end

    transactions
  end

  def output
    File.open('output.json', 'w') do |file|
      fetch_transactions(browser).each do |transaction|
        PP.pp(transaction[1], file)
      end
    end
  end
end
