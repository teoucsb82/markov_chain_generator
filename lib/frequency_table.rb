class MarkovChain
  # Not meant to be called directly, used for isolation & testing.
  # Please use the main MarkovChain class to invoke these

  class FrequencyTable
    def initialize(text, options = {})
      @text = text
      @options = default_options.merge(options)
    end

    def to_h
      table = {}
      text_array.each_with_index do |token, i|
        table[token] ||= {}
        if i + 1 == text_array.length 
          # end of list, map last token back to the first
          next_token = text_array[0]
        else
          next_token = text_array[i+1]
        end
        table[token][next_token] ||= 0
        table[token][next_token] += 1  
      end
      table
    end

    def to_s
      starting_word = self.to_h.select { |k, v| v.present? }.keys.sample
      results = [starting_word]

      while results.length < @options[:max_length]
        next_word = select_next_word_from(results)
        # break unless next_word
        results << next_word
      end
      results = results.join(' ')

      # restore punctuation spacing
      punctuation.each do |punc|
        results.gsub!(" #{punc}", "#{punc}")
      end

      # capitalize the first letter of each sentence (against . ! ?)
      results.gsub(/[a-z][^.?!]*/) { |match| match[0].upcase + match[1..-1].rstrip }
    end

    private
    def default_options
      options = {}
      options[:max_length] = to_h.keys.length
      options
    end

    def punctuation
      ['.', ',', '!', '?', ';', ':', '-']
    end

    def select_next_word_from(results)
      key = results.last
      possible_next_words = self.to_h[key].keys

      # if there's only one word that follows, return it and break
      return possible_next_words.first if possible_next_words.length == 1

      weighted_hash = {}
      total_weight = self.to_h[key].values.sum.to_f
      possible_next_words.each do |word|
        weighted_hash[word] = self.to_h[key][word] / total_weight
      end

      weighted_hash.max_by { |_, weight| rand ** (1.0 / weight) }.first
    end

    def text_array
      text_array = @text.split(' ').map(&:downcase)
      text_array.map! do |token|
        last_character = token[-1]
        if last_character.in?(punctuation)
          [token.delete(last_character), last_character]
        else
          token
        end
      end
      text_array.flatten
    end
  end
end
