class TwitterUsersController < ApplicationController
  respond_to :html, :json

  def index
    # used for form on main page
    @twitter_user = TwitterUser.new

    @twitter_users = TwitterUser.all
  end

  def create
    @twitter_user = TwitterUser.create(twitter_user_params)
    respond_with(@twitter_user)
  end

  def show
    @twitter_user = TwitterUser.find(params[:id])
    @tweets = @twitter_user.tweets
    respond_with(@twitter_user)
  end

  private
  def twitter_user_params
    params.require(:twitter_user).permit(:name)
  end
end
