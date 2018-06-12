require_relative './frequency_table'

class ChainGenerator
  attr_reader :frequency_table

  def initialize(text, options = {})
    @frequency_table = ChainGenerator::FrequencyTable.new(text, options)
  end

  def generate
    frequency_table.to_s
  end
end
