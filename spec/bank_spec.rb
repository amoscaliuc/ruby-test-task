# frozen_string_literal: true

require '../lib/bank'
require '../lib/account'
require '../lib/transaction'
require_relative '../lib/exception/html_empty_error'
require 'nokogiri'

# Test Bank Class
RSpec.describe Bank do
  def bank_entity
    Bank.new
  end

  context 'bank accounts' do
    it 'check number of accounts and the result' do
      file = File.open('spec/samples/accounts.html', 'r')
      html = Nokogiri::HTML(file.read)
      accounts = bank_entity.parse_accounts(html)

      expect(accounts.count).to eq(3)
      expect(accounts.first[1]).to eq(
        {
          'name'         => '40817810200000055320',
          'currency'     => 'RUB',
          'balance'      => 1_000_000.0,
          'nature'       => 'Активный',
          'transactions' => {}
        }
      )
    end

    #     it "raise error" do
    #       accounts = bank_entity.parse_accounts('')
    #
    #       expect { accounts }.to raise_error { |error|
    #         expect(error).to be_a(HtmlEmptyError)
    #       }
    #     end
  end

  context 'account transactions' do
    it 'check count and parse transactions' do
      file = File.open('spec/samples/transactions.html', 'r')
      html = Nokogiri::HTML(file.read)
      transactions = bank_entity.parse_transactions(html, '40817810200000055320')

      expect(transactions.count).to eq(5)
      expect(transactions.first[1]).to eq(
        {
          'date'         => '01.12.2020',
          'amount'       => 50.0,
          'currency'     => '₽',
          'account_name' => '40817810200000055320',
          'description'  => 'Оплата услуг МегаФон Урал, Номер телефона: 79111111111, 01.12.2020 11:59:59, Сумма 50.00 RUB, Банк-он-ЛайнСтатусУспешно Тип операцииОплата услугСумма операции50.00 ₽Проведено50.00 ₽Комиссия0.00 ₽Дата обработки01.12.2020Информация о терминалеBank-on-line, Россия, Ekaterinburg, ul. Chapaeva 3aОписаниеОплата услуг МегаФон Урал, Номер телефона: 79111111111, 01.12.2020 11:59:59, Сумма 50.00 RUB, Банк-он-ЛайнНомер телефона9111111111'
        }
      )
    end

    #     it "raise error" do
    #       account = Account.new
    #       account.name = '40817810200000055320'
    #       account.currency = 'RUB'
    #       mock_account = { '40817810200000055320' => account }
    #       transactions = bank_entity.parse_transactions('', mock_account.to_a[0])
    #
    #       expect { transactions }.to raise_error { |error|
    #         expect(error).to be_a(HtmlEmptyError)
    #       }
    #     end
  end
end
