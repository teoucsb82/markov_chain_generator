class ChainGenerator
  attr_reader :frequency_table

  def initialize(text, options = {})
    @frequency_table = FrequencyTable.new(text, options)
  end

  def generate
    frequency_table.to_s
  end
end
