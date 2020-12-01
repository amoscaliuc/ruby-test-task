# frozen_string_literal: true

require_relative 'lib/watir_browser'
require 'pp'

# Watir implementation
watir = WatirBrowser.new
accounts = watir.bank_accounts

pp accounts
