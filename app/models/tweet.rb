class Tweet < ActiveRecord::Base
  belongs_to :twitter_user
  validates_presence_of :body
end
