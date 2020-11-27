require_relative "lib/nokogiri_css"

nokogiri = NokogiriCss.new
accounts = nokogiri.accounts

p accounts