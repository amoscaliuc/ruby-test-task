# frozen_string_literal: true

require 'watir'
require_relative 'account'
require_relative 'transaction'
require 'date'

# Base class with common methods
class Base
  def get_currency(string)
    result = string.split(' ')
    result[1] || '-'
  end

  def get_balance(string)
    format '%.2f', string.delete(' ').to_f
  rescue ArgumentError
    nil
  end

  def to_hash(object)
    hash = {}
    object.instance_variables.each {|var| hash[var.to_s.delete("@")] = object.instance_variable_get(var) }
    hash
  end
end
