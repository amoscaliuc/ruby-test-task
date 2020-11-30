require "rubygems"
require_relative "base"
require_relative "exception/account_empty_error"
require_relative "exception/transaction_empty_error"

class WatirBrowser < Base
  def bank_accounts
    accounts = default_accounts
    transactions = default_transactions
    browser = watir_browser_init

    begin
      browser.table(id: 'contracts-list').rows(class: 'cp-item').each do |row|
        account = Array.new
        row.cells.each do |cell|
          if cell.text != ""
            account << cell.text
          end
        end

        if account == []
          raise AccountEmptyError, "No accounts detected!"
        end

        account_number = account[0]
        accounts[account_number].number = account_number
        accounts[account_number].type = account[1]
        accounts[account_number].status = account[2]
        accounts[account_number].amount = account[3]
      end
    rescue AccountEmptyError => error
      puts "Error: #{error.message}"
    end
    accounts.each do |account|
      transaction_account_number = account[0]
      browser.goto "https://demo.bank-on-line.ru/#Contracts/#{transaction_account_number}/Transactions"
      browser.span(id: 'getTranz').click
      count = 0

      begin
        browser.table(class: 'cp-tran-with-balance').rows(class: 'cp-transaction').each do |row|
          transaction = Array.new
          row.cells.each do |cell|
            if cell.text != ""
              transaction << cell.text
            end
          end

          if transaction == []
            raise TransactionEmptyError, "No transactions detected!"
          end

          transaction_date = transaction[3]
          if date_two_months_old(transaction_date)
            transactions[count].date = transaction_date
            transactions[count].amount = transaction[4]
            transactions[count].description = transaction[2]
            transactions[count].accountNumber = transaction_account_number

            accounts[transaction_account_number].transactions = transactions
            count += 1
          end
        end
      rescue TransactionEmptyError => error
        puts "Error: #{error.message}"
      end
    end
  end
end