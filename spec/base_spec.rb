# frozen_string_literal: true

require '../lib/base'
require '../lib/account'
require '../lib/transaction'

# Test Base Class
RSpec.describe Base do
  def base_entity
    Base.new
  end

  context 'operations' do
    it 'get currency' do
      expect(base_entity.get_currency('10 USD')).to eq('USD')
    end

    it 'get balance' do
      expect(base_entity.get_balance('10 000.00')).to eq('10000.00')
    end
  end
end
