require_relative "lib/watir_browser"
require_relative "lib/exception/account_empty_error"

watir = WatirBrowser.new
accounts = watir.accounts

p accounts