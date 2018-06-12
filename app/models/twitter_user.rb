class TwitterUser < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]
  
  validates_presence_of :name

  has_many :markov_chains
  has_many :tweets
end
