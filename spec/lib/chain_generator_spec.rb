require 'rails_helper'
require 'chain_generator'
require 'frequency_table'

RSpec.describe ChainGenerator, type: :model do
  subject(:chain_generator) { ChainGenerator.new(text, options) }
  let(:text) { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' }
  let(:options) { Hash.new }

  describe 'initialize' do
    it { expect(chain_generator).to be_a(ChainGenerator) }
  end

  describe '#frequency_table' do
    subject(:frequency_table) { chain_generator.frequency_table }
    it { expect(frequency_table).to be_a(ChainGenerator::FrequencyTable) }
  end

  describe '#generate' do
    subject(:generate) { chain_generator.generate }
    let(:frequency_table) { chain_generator.frequency_table }
    
    it 'calls FrequencyTable#to_s' do
      expect(frequency_table).to receive(:to_s)
      generate
    end

    # context 'with options' do
      # context 'max_words_length' do
      #   describe 'default' do

      #     it 'is the same length as the original string' do
      #       expect(generate.size).to eq text.size
      #     end
      #   end

      #   describe 'max_words_length overrides' do
      #     let(:options) { { max_words_length: 1 } }
      #     it { expect(generate.split(' ').length).to eq 1 } 
      #   end
      # end
    # end
  end
end
