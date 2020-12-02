# frozen_string_literal: true

require 'rubygems'
require 'watir'
require 'nokogiri'
require 'date'
require_relative 'base'
require_relative 'exception/account_empty_error'
require_relative 'exception/transaction_empty_error'

# Nokogiri implementation
class Bank < Base
  def connect
    browser = Watir::Browser.new
    browser.goto 'https://demo.bank-on-line.ru'
    browser.div(class: 'button-demo').click
    browser
  end

  def fetch_accounts
    browser = connect
    browser.goto 'https://demo.bank-on-line.ru/#Contracts'
    html = Nokogiri::HTML.fragment(browser.table(id: 'contracts-list').html)
    parse_accounts(html)
  end

  def parse_accounts(html)
    accounts = default_accounts
    begin
      table_rows = html.css('tr.cp-item')
      text_all_rows = table_rows.map do |row|
        row_values = row.css("td[data-action='show-contract-info']").map(&:text)
        row_values.reject(&:empty?)
      end

      raise AccountEmptyError, 'No accounts detected!' if text_all_rows == []

      text_all_rows.each do |account|
        account_number = account[0]
        accounts[account_number].name = account_number
        accounts[account_number].currency = get_currency(account[1])
        accounts[account_number].balance = get_balance(account[3]).to_f
        accounts[account_number].nature = account[2]
      end
    rescue AccountEmptyError => e
      puts "Error: #{e.message}"
    end

    accounts
  end

  def fetch_transactions
    accounts = fetch_accounts
    browser = connect
    accounts.each do |account|
      account_name = account[1].name
      browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_name}/Transactions"
      # input = Nokogiri::HTML.fragment(browser.input(id: "DateTo").html)
      # input.at('input')['value'] = Date.today.prev_month(2)
      browser.span(id: 'getTranz').click # TODO: set dateFrom to 2 months before click
      html = Nokogiri::HTML.fragment(browser.table(class: 'cp-tran-with-balance').html)
      accounts[account_name].transactions = parse_transactions(html, account)
    end

    accounts
  end

  def parse_transactions(html, account)
    transactions = default_transactions
    begin
      table_rows = html.css('tr.cp-transaction')
      text_all_rows = table_rows.map do |row|
        row_values = row.css("td[data-action='transaction-show-details']").map(&:text)
        row_values.reject(&:empty?)
      end

      raise TransactionEmptyError, 'No transactions detected!' if text_all_rows == []

      count = 0
      text_all_rows.each do |transaction|
        transactions[count].date = transaction[3]
        transactions[count].description = transaction[2]
        transactions[count].amount = get_balance(transaction[4]).to_f
        transactions[count].currency = account[1].currency
        transactions[count].account_name = account[1].name
        count += 1
      end

      transactions
    rescue TransactionEmptyError => e
      puts "Error: #{e.message}"
    end
  end

  def output
    File.open('output.json', 'w') do |file|
      fetch_transactions.each do |transaction|
        PP.pp(transaction[1], file)
      end
    end
  end
end
