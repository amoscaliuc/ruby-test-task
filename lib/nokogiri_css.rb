require "rubygems"
require "watir"
require "nokogiri"
require "date"
require_relative "account"
require_relative "transaction"
require_relative "base"
require_relative "exception/account_empty_error"
require_relative "exception/transaction_empty_error"

class NokogiriCss < Base
  def bank_accounts
    accounts = default_accounts
    transactions = default_transactions
    browser = watir_browser_init
    sleep(5) #TODO: find another way for the watir html extraction delay
    page = Nokogiri::HTML.parse(browser.html)

    begin
      table_rows = page.css('table#contracts-list tr.cp-item')
      text_all_rows = table_rows.map do |row|
        row_values = row.css("td[data-action='show-contract-info']").map(&:text)
        row_values.reject { |c| c.empty? }
      end

      if text_all_rows == []
        raise AccountEmptyError, "No accounts detected!"
      end

      text_all_rows.each do |account|
        account_number = account[0]
        accounts[account_number].number = account_number
        accounts[account_number].type = account[1]
        accounts[account_number].status = account[2]
        accounts[account_number].amount = account[3]
      end
    rescue AccountEmptyError => error
      puts "Error: #{error.message}"
    end

    begin
      accounts.each do |account|
        account_number = account[0]
        browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_number}/Transactions"
        browser.span(id: 'getTranz').click
        sleep(5) #TODO: find another way for the watir html extraction delay
        page = Nokogiri::HTML.parse(browser.html)
        table_rows = page.css('table.cp-tran-with-balance tr.cp-transaction')
        text_all_rows = table_rows.map do |row|
          row_values = row.css("td[data-action='transaction-show-details']").map(&:text)
          row_values.reject { |c| c.empty? }
        end

        if text_all_rows == []
          raise TransactionEmptyError, "No transactions detected!"
        end

        count = 0
        text_all_rows.each do |transaction|
          transaction_date = transaction[3]
          if date_two_months_old(transaction_date)
            transactions[count].date = transaction_date
            transactions[count].amount = transaction[4]
            transactions[count].description = transaction[2]
            transactions[count].accountNumber = account_number

            accounts[account_number].transactions = transactions
            count += 1
          end
        end
      end
    rescue TransactionEmptyError => error
      puts "Error: #{error.message}"
    end
  end
end