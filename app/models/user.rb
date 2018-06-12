class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]
  
  validates_presence_of :name
  has_many :tweets

  after_create :save_most_recent_tweets

  def markov_chain
    text = tweets.pluck(:body)
    chain = ChainGenerator.new(text.join(' '))
    chain.generate
  end

  private
  def save_most_recent_tweets
    # fetch and save the most recent 3 tweets
    client = TwitterAPI.new.client
    options = { count: 3, include_rts: true }

    client.user_timeline(name, options).each do |tweet|
      tweets.create(body: tweet.text)
    end
  end
end
