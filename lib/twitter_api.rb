class TwitterAPI
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def get_all_tweets(user)
    collect_with_max_id do |max_id|
      begin
        options = {count: 200, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?
        client.user_timeline(user, options)
      rescue Twitter::Error::TooManyRequests => error
        sleep error.rate_limit.reset_in + 1
      end
    end
  end

  private
  # https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end
end