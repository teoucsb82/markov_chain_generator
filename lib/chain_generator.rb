require_relative './frequency_table'

class ChainGenerator
  attr_reader :frequency_table
  attr_reader :text

  def initialize(text, options = {})
    @text = text
    @frequency_table = ChainGenerator::FrequencyTable.new(text, options)
  end

  def generate
    frequency_table.to_s
  end
end
