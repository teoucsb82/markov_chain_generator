require 'rails_helper'
require 'frequency_table'

RSpec.describe MarkovChain::FrequencyTable, type: :model do
  subject(:frequency_table) { MarkovChain::FrequencyTable.new(text) }
  let(:text) { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' }

  describe '#to_h' do
    subject { frequency_table.to_h }
    let(:text) { 'word all word possible word following word choices' }

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end

    it 'returns a list of each word in the text with counts of each word that somes after them' do
      expect(subject).to eq(
        'word' => {
          'all' => 1,
          'possible' => 1,
          'following' => 1,
          'choices' => 1
        },
        'all' => { 'word' => 1 },
        'possible' => { 'word' => 1 },
        'following' => { 'word' => 1 },
        'choices' => { 'word' => 1 }
      )
    end

    context 'end of chain' do
      let(:alphabet) { ('a'..'z').to_a.join(' ') }
      let(:text) { alphabet }

      it 'points the last token of the chain back to the first' do
        expect(subject['a'].keys).to eq(['b'])
        expect(subject['b'].keys).to eq(['c'])

        expect(subject['y'].keys).to eq(['z'])
        expect(subject['z'].keys).to eq(['a'])
      end
    end

    context 'punctuation' do
      let(:text) { 'is. punctuation, included! in; the - main table: hash?' }

      it 'treats punctuation as individual, unique elements' do
        expect(subject.keys).to include('.')
        expect(subject.keys).to include(',')
        expect(subject.keys).to include('!')
        expect(subject.keys).to include('?')
        expect(subject.keys).to include(';')
        expect(subject.keys).to include(':')
        expect(subject.keys).to include('-')
      end
    end
  end

  describe '#to_s' do
    subject { frequency_table.to_s }
    let(:text) { 'hello world' }

    it { expect(subject).to be_a(String) }

    context 'punctuation formatting' do
      let(:text) { 'no spaces in these commas, questions? and exclamations!' }

      it 'removes leading spaces from punctuation' do
        expect(subject.match(' \,')).to be_nil
        expect(subject.match('\,')).not_to be_nil

        expect(subject.match(' \?')).to be_nil
        expect(subject.match('\?')).not_to be_nil

        expect(subject.match(' \!')).to be_nil
        expect(subject.match('\!')).not_to be_nil
      end
    end
  end
end
