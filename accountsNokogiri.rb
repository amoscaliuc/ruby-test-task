require_relative "lib/nokogiri_css"

# Nokogiri implementation
nokogiri = NokogiriCss.new
accounts = nokogiri.bank_accounts

p accounts