class ChainGenerator
  # Not meant to be called directly, used for isolation & testing.
  # Please use the main MarkovChain class to invoke these

  class FrequencyTable
    def initialize(text, options = {})
      @text = text
      @options = default_options.merge(options)
    end

    def to_h
      return @table if @table
      @table = {}
      text_array.each_with_index do |token, i|
        @table[token] ||= {}
        if i + 1 == text_array.length 
          # end of list, map last token back to the first
          next_token = text_array[0]
        else
          next_token = text_array[i+1]
        end
        @table[token][next_token] ||= 0
        @table[token][next_token] += 1  
      end
      @table
    end

    def to_s
      results = [starting_word]

      max_length = 140 #keep generated tweet under 140 char.
      while results.join(' ').length <= max_length
        next_word = select_next_word_from(results)
        results << next_word
      end
      
      # loop above might go above the max_length char limit.
      if results.join(' ').length > max_length
        results = results[0..-1] 
      end

      results = results.join(' ')
      trim_leading_punctuation_from!(results)

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

    def starting_word
      # pick a random word that is not punctuation
      to_h.keys.reject{ |token| token.in?(punctuation) }.sample
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

    def trim_leading_punctuation_from!(results)
      punctuation.each do |punc|
        # trim leading space near punctuation
        # ex: "this , is . some text !" becomes "this, is. some text!"
        results.gsub!(" #{punc}", "#{punc}")
      end
    end
  end
end
