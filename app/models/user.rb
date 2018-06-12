class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]
  
  validates_presence_of :name
  has_many :tweets

  after_create :save_most_recent_tweets

  def markov_chain(number_of_tweets = 3)
    text = tweets.pluck(:body).sample(number_of_tweets).join(' ')
    chain = ChainGenerator.new(text)
  end

  private
  def save_most_recent_tweets
    # fetch and save the most recent 20 tweets
    client = TwitterAPI.new.client
    options = { count: 20, include_rts: true }

    client.user_timeline(name, options).each do |tweet|
      tweets.create(body: tweet.text)
    end
  end
end
