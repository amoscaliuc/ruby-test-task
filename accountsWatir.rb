require_relative "lib/watir_browser"

# Watir implementation
watir = WatirBrowser.new
accounts = watir.bank_accounts

p accounts