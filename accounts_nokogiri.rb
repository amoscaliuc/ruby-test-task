# frozen_string_literal: true

require_relative 'lib/nokogiri_css'
require 'pp'

# Nokogiri implementation
nokogiri = NokogiriCss.new
accounts = nokogiri.bank_accounts

pp accounts
