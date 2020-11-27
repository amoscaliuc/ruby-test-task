require "rubygems"
require "watir"
require "date"
require_relative "account"
require_relative "transaction"

class WatirBrowser
  def accounts
    accounts = Hash.new do |hash, key|
      account = Account.new
      account.transactions = {}
      hash[key] = account
    end

    transactions = Hash.new do |hash, key|
      transaction = Transaction.new
      hash[key] = transaction
    end

    browser = Watir::Browser.new :chrome
    browser.goto "https://demo.bank-on-line.ru"
    browser.div(class: 'button-demo').click
    browser.goto "https://demo.bank-on-line.ru/#Contracts"

    row_counter = 0
    browser.table(id: 'contracts-list').rows(class: 'cp-item').each do |row|
      row_array = Array.new
      row.cells.each do |cell|
        if cell.text != ""
          row_array << cell.text
        end
      end

      account_number = row_array[0]
      accounts[account_number].number = account_number
      accounts[account_number].type = row_array[1]
      accounts[account_number].status = row_array[2]
      accounts[account_number].amount = row_array[3]

      row_counter += 1
    end

    accounts.each do |account|
      account_number = account[0]
      browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_number}/Transactions"
      browser.span(id: 'getTranz').click
      count = 0
      browser.table(class: 'cp-tran-with-balance').rows(class: 'cp-transaction').each do |row|
        row_array = Array.new
        row.cells.each do |cell|
          if cell.text != ""
            row_array << cell.text
          end
        end

        transaction_date = row_array[3]
        date_range = Date.parse transaction_date
        if (date_range.month) >= Date.today.month - 2
          transactions[count].date = transaction_date
          transactions[count].amount = row_array[4]
          transactions[count].description = row_array[2]
          transactions[count].accountNumber = account_number

          accounts[account_number].transactions = transactions
          count += 1
        end
      end
    end
  end
end