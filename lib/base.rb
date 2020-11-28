require "watir"
require_relative "account"
require_relative "transaction"
require "date"

class Base
  def default_accounts
    Hash.new do |hash, key|
      account = Account.new
      account.transactions = {}
      hash[key] = account
    end
  end

  def default_transactions
    Hash.new do |hash, key|
      transaction = Transaction.new
      hash[key] = transaction
    end
  end

  def watir_browser_init
    browser = Watir::Browser.new
    browser.goto "https://demo.bank-on-line.ru"
    browser.div(class: 'button-demo').click
    browser.goto "https://demo.bank-on-line.ru/#Contracts"
    browser
  end

  def date_two_months_old(date)
    date_range = Date.parse date
    (date_range.month) >= Date.today.month - 2
  end
end